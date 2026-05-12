import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../sales_service.dart';

class PickedPdfFile {
  final String name;
  final String path;

  const PickedPdfFile({required this.name, required this.path});
}

class CreateQuotationScreen extends StatefulWidget {
  final String taskId;
  final String projectId;

  const CreateQuotationScreen({
    super.key,
    required this.taskId,
    required this.projectId,
  });

  @override
  State<CreateQuotationScreen> createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends State<CreateQuotationScreen> {
  final SalesService salesService = SalesService();

  final TextEditingController amountController = TextEditingController();

  final TextEditingController advanceController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  bool isLoading = false;

  /// MULTIPLE PDF FILES
  final List<PickedPdfFile> pdfFiles = [];

  /// PICK PDFs
  Future<void> pickPdfFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        for (final pickedFile in result.files) {
          final path = pickedFile.path;

          if (path == null) continue;

          final alreadyAdded = pdfFiles.any((pdf) => pdf.path == path);

          if (!alreadyAdded) {
            pdfFiles.add(PickedPdfFile(name: pickedFile.name, path: path));
          }
        }
      });
    }
  }

  /// CREATE QUOTATION
  Future<void> createQuotation({required String status}) async {
    if (pdfFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one PDF')),
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final double totalAmount = double.tryParse(amountController.text) ?? 0;

      final double advancePaid = double.tryParse(advanceController.text) ?? 0;

      /// CONVERT PDFs TO BASE64
      final List<String> pdfBase64List = [];

      for (final pdfFile in pdfFiles) {
        final bytes = await File(pdfFile.path).readAsBytes();

        final base64Pdf = base64Encode(bytes);

        pdfBase64List.add(base64Pdf);
      }

      /// CREATE QUOTATION
      final quotationRes = await salesService.createQuotation(
        taskId: widget.taskId,
        amount: totalAmount,
        advancePaid: advancePaid > 0 ? advancePaid : null,
        approvalStatus: status,

        /// SEND LIST OF PDFs
        pdfs: pdfBase64List,
      );
      print(quotationRes);
      if (quotationRes['success'] != true) {
        throw Exception(
          quotationRes['message'] ?? 'Failed to create quotation',
        );
      }

      final quotationId = quotationRes['data']['id'];

      /// CREATE PAYMENT
      if (advancePaid > 0) {
        final a = await salesService.createPayment(
          projectId: widget.projectId,
          quotationId: quotationId,
          amount: advancePaid,
          type: 'ADVANCE',
          reference: '',
          paidAt: DateTime.now(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'SENT'
                ? 'Quotation sent successfully'
                : 'Quotation saved as draft',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    advanceController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Create Quotation",
          style: TextStyle(color: Colors.black),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// TOTAL AMOUNT
            inputField(
              label: "Total Amount",
              controller: amountController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            /// ADVANCE PAID
            inputField(
              label: "Advance Paid",
              controller: advanceController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            /// NOTES
            inputField(
              label: "Notes / Terms",
              controller: notesController,
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            /// PDF SECTION
            const Text(
              "Quotation PDFs",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: pickPdfFiles,

              icon: const Icon(Icons.upload_file),

              label: const Text("Add PDF Files"),
            ),

            const SizedBox(height: 10),

            /// PDF LIST
            if (pdfFiles.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: pdfFiles.asMap().entries.map((entry) {
                    final index = entry.key;

                    final file = entry.value;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),

                      title: Text(file.name),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () {
                          setState(() {
                            pdfFiles.removeAt(index);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 30),

            /// SEND BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),

                backgroundColor: Colors.teal,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onPressed: isLoading
                  ? null
                  : () async {
                      await createQuotation(status: 'SENT');
                    },

              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,

                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),

              label: const Text(
                "Send to Customer",

                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),

            /// SAVE DRAFT
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),

                side: const BorderSide(color: Colors.teal),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onPressed: isLoading
                  ? null
                  : () async {
                      await createQuotation(status: 'DRAFT');
                    },

              icon: const Icon(Icons.save, color: Colors.teal),

              label: const Text(
                "Save as Draft",

                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
