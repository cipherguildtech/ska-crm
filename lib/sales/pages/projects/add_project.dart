import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            ),

            const SizedBox(height: 12),

            buildDropdown(),

            const SizedBox(height: 20),

            const SectionTitle(
              title: "Project Details",
              icon: CupertinoIcons.briefcase,
            ),

            const Text("Service Type *"),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: services.map((service) {
                final selected = selectedServices.contains(service);
                return ChoiceChip(
                  label: Text(service),
                  selected: selected,
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
              "Project Description *",
              descController,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            buildDatePicker(),

            const SizedBox(height: 16),

            const Text("Attachments (Up to 3)"),
            const SizedBox(height: 8),

            Row(
              children: [
                buildAttachmentBox(icon: Icons.add),
                buildAttachmentBox(),
                buildAttachmentBox(),
              ],
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                "Reset All Fields",
                style: TextStyle(color: Colors.grey),
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
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
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
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
        const Text("Customer Type *"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: customerType,
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
        const Text("Deadline *"),
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
