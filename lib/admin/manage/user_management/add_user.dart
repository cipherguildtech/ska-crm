import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:ska_crm/utils/config.dart';

class AddUserScreen extends StatefulWidget {
  final bool isEdit;
  final String? phone;

  const AddUserScreen({
    super.key,
    this.isEdit = false,
    this.phone,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscurePassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  String? selectedDept;

  final List<String> roles = [
    'ADMIN',
    'HR',
    'SALES',
    'TEAM',
  ];

  final List<String> departments = [
    'DESIGNING',
    'SITE_VISITING',
    'MARKETING',
    'WELDING',
    'FITTING',
    'TRANSPORT',
    'PRINTING',
    'CNC_CUTTING',
    'LASER',
    'LETTER_MAKING',
    'ERRACTON',
    'ORDER',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.phone != null) {
      fetchUserDetails();
    }
  }

  String generatePassword() {
    return "Abc@1234";
  }

  Future<void> fetchUserDetails() async {
    try {
      setState(() => isLoading = true);

      final response = await http.get(
        Uri.parse(
          "$baseUrl/users/full_detail/${widget.phone}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        nameController.text = data['full_name'] ?? '';
        emailController.text = data['email'] ?? '';
        String phone = data['phone'] ?? '';

        /// REMOVE +91 PREFIX
        if (phone.startsWith("+91")) {
          phone = phone.substring(3);
        }

        phoneController.text = phone;

        selectedRole = data['role'];
        selectedDept = data['department'];

        setState(() {});
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      late http.Response response;

      /// =========================
      /// CREATE USER BODY
      /// =========================
      if (!widget.isEdit) {

        final createBody = {
          "full_name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": "+91${phoneController.text.trim()}",
          "password": passwordController.text.trim(),
          "role": selectedRole,
          "department": selectedDept,
        };

        response = await http.post(
          Uri.parse("$baseUrl/auth/register"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(createBody),
        );
      }

      /// =========================
      /// UPDATE USER BODY
      /// =========================
      else {

        final updateBody = {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password":
          passwordController.text.trim().isEmpty
              ? null
              : passwordController.text.trim(),
          "role": selectedRole,
          "department": selectedDept,
        };

        response = await http.put(
          Uri.parse(
            "$baseUrl/users/update_details/${widget.phone}",
          ),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(updateBody),
        );
      }

      /// SUCCESS
      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEdit
                  ? "User Updated Successfully"
                  : "User Created Successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);

      } else {

        final error = jsonDecode(response.body);

        throw Exception(
          error['message'] ?? 'Something went wrong',
        );
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  InputDecoration inputDecoration({
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: icon != null
          ? Icon(icon, color: Colors.teal)
          : null,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 1.5,
        ),
      ),
    );
  }

  Widget sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.teal),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7F9),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.isEdit
              ? "Edit User"
              : "Add New User",
        ),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// PERSONAL INFO
            sectionTitle(
              icon: Icons.person_outline,
              title: "Personal Information",
              subtitle:
              "Basic user profile details",
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"[a-zA-Z\s]"),
                ),
              ],
              decoration: inputDecoration(
                hint: "Full Name",
                icon: Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Full name is required";
                }

                if (value.trim().length < 3) {
                  return "Enter valid name";
                }

                return null;
              },
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecoration(
                hint: "Email Address",
                icon: Icons.email_outlined,
              ),
              validator: (value) {

                if (value == null || value.trim().isEmpty) {
                  return "Email is required";
                }

                final emailRegex = RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                );

                if (!emailRegex.hasMatch(value.trim())) {
                  return "Enter valid email";
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: phoneController,
              readOnly: widget.isEdit,
              keyboardType: TextInputType.number,
              maxLength: 10,

              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],

              decoration: inputDecoration(
                hint: "Phone Number",
                icon: Icons.phone_outlined,
              ).copyWith(
                counterText: "",
              ),

              validator: (value) {

                if (value == null || value.trim().isEmpty) {
                  return "Phone number required";
                }

                if (value.length != 10) {
                  return "Phone number must be 10 digits";
                }

                return null;
              },
            ),

            const SizedBox(height: 28),

            /// ROLE
            sectionTitle(
              icon: Icons.work_outline,
              title: "Role & Department",
              subtitle:
              "Manage user access & assignment",
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: inputDecoration(
                hint: "Select Role",
                icon: Icons.admin_panel_settings_outlined,
              ),
              items: roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;

                  /// CLEAR DEPARTMENT IF NOT TEAM
                  if (selectedRole != "TEAM") {
                    selectedDept = null;
                  }
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Role required";
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            /// SHOW DEPARTMENT ONLY FOR TEAM ROLE
            if (selectedRole == "TEAM") ...[
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: selectedDept,
                decoration: inputDecoration(
                  hint: "Select Department",
                  icon: Icons.apartment_outlined,
                ),
                items: departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(
                      dept.replaceAll("_", " "),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDept = value;
                  });
                },
                validator: (value) {
                  if (selectedRole == "TEAM" && value == null) {
                    return "Department required";
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 28),

            /// PASSWORD ONLY FOR CREATE USER
            if (!widget.isEdit) ...[
              sectionTitle(
                icon: Icons.lock_outline,
                title: "Account Security",
                subtitle: "Create secure login credentials",
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: "Enter Password",

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.teal,
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password required";
                  }

                  final passwordRegex = RegExp(
                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
                  );

                  if (!passwordRegex.hasMatch(value)) {
                    return "Use 8+ chars, uppercase, number & symbol";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  passwordController.text = generatePassword();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password Generated"),
                    ),
                  );
                },
                child: DottedBorder(
                  color: Colors.teal,
                  strokeWidth: 1.2,
                  dashPattern: const [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restart_alt,
                          color: Colors.teal,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "Auto Generate Password",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],

            SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),
                onPressed:
                isLoading ? null : submitForm,
                child: isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child:
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  widget.isEdit
                      ? "Update User"
                      : "Create User Account",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}