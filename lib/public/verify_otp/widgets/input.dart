import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class OtpInput extends StatelessWidget {
  final List<TextEditingController> controllers;

  const OtpInput({super.key, required this.controllers});

  Widget _otpBox(BuildContext context, int index) {
    return SizedBox(
      width: 55,
      child: TextField(
        controller: controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        cursorColor: Colors.teal,
        maxLength: 1,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          counterText: "",
          focusColor: Colors.teal,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < controllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children:
      List.generate(controllers.length, (i) => _otpBox(context, i)),
    );
  }
}