import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ska_crm/admin/widgets/navbar.dart';

class NewCustomerProjectScreen extends StatefulWidget {
  const NewCustomerProjectScreen({super.key});

  @override
  State<NewCustomerProjectScreen> createState() =>
      _NewCustomerProjectScreenState();
}

class _NewCustomerProjectScreenState extends State<NewCustomerProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String customerType = "REFERRAL";
  DateTime selectedDate = DateTime.now();

  List<String> selectedServices = [];

  final List<String> services = [
    'ADS',
    'BOARD',
    'BANNER',
    'LED_BOARD',
    'ROAD_SHOW',
    'INVITATION',
    'CARD',
    'DESIGN',
    'PAMPLET',
    'VISITING_CARD',
    'BRANDING',
    'OTHERS',
  ];
  final ImagePicker _picker = ImagePicker();
  List<File> images = [];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "New Customer & Project",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.save, color: primary, size: 17),
                Text("Draft", style: TextStyle(color: Colors.teal)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: "Customer Details",
              icon: Icons.person_2_outlined,
            ),

            buildTextField("Full Name", nameController, isRequired: true),

            const SizedBox(height: 12),

            buildPhoneField(),

            const SizedBox(height: 12),

            buildTextField("Email (Optional)", emailController),

            const SizedBox(height: 12),

            buildTextField(
              "Address",
              null,
              hint: "Enter installation site or billing address...",

              isRequired: true,
            ),

            const SizedBox(height: 12),

            buildDropdown(),

            const SizedBox(height: 20),

            const SectionTitle(
              title: "Project Details",
              icon: CupertinoIcons.briefcase,
            ),

            Row(
              children: [
                const Text("Service Type"),
                SizedBox(width: 5),
                const Text("*", style: TextStyle(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: services.map((service) {
                final selected = selectedServices.contains(service);
                return ChoiceChip(
                  label: Text(service),
                  labelStyle: TextStyle(
                    color: selectedServices.contains(service)
                        ? Colors.white
                        : Colors.black,
                  ),
                  checkmarkColor: selectedServices.contains(service)
                      ? Colors.white
                      : Colors.black,
                  selected: selected,
                  selectedColor: primary,
                  onSelected: (_) {
                    setState(() {
                      selected
                          ? selectedServices.remove(service)
                          : selectedServices.add(service);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            buildTextField(
              "Project Description",
              descController,
              maxLines: 4,
              isRequired: true,
            ),

            const SizedBox(height: 16),

            buildDatePicker(),

            const SizedBox(height: 16),

            const Text("Attachments (Up to 3)"),
            const SizedBox(height: 8),

            _attachmentsRow(),

            const SizedBox(height: 24),

            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    images.clear();
                  });
                },
                child: const Text(
                  "Reset All Fields",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("VALIDATION STATUS"),
                Text("READY TO SUBMIT", style: TextStyle(color: Colors.teal)),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {},
                child: const Text(
                  "Create Project",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentsRow() {
    return Column(
      children: [
        Row(
          children: [
            ...images.map(
              (img) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            images.remove(img);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _addBox(),
          ],
        ),
        Row(
          children: [
            Icon(Icons.image, color: Colors.grey),
            SizedBox(width: 5),
            Text("Supported: JPG, PNG(Max 8MB)"),
          ],
        ),
      ],
    );
  }

  Widget _addBox() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Icon(Icons.add)),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController? controller, {
    String? hint,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label),
            SizedBox(width: 5),
            if (isRequired) Text("*", style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return "$label is required";
            }

            // Email validation (only if label matches AND value is not empty)
            if (label == "Email (Optional)" &&
                value != null &&
                value.isNotEmpty) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

              if (!emailRegex.hasMatch(value)) {
                return "Enter a valid email address";
              }
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget buildPhoneField() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Phone Number"),
              SizedBox(width: 5),
              const Text("*", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("+91"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    }

                    // Regex for Indian mobile numbers
                    final regex = RegExp(r'^[6-9]\d{9}$');

                    if (!regex.hasMatch(value)) {
                      return "Enter a valid 10-digit number";
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Customer Type"),
            SizedBox(width: 5),
            const Text("*", style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: customerType,
          items: [
            "REFERRAL",
            "WALK-IN",
            "ONLINE",
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            setState(() {
              customerType = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Deadline"),
            SizedBox(width: 5),
            const Text("*", style: TextStyle(color: Colors.red)),
          ],
        ),

        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );

            if (picked != null) {
              setState(() => selectedDate = picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAttachmentBox({IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: icon != null
          ? Icon(icon)
          : const Icon(Icons.image, color: Colors.grey),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Icon(icon, color: Colors.teal),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
