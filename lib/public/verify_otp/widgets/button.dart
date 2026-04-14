import 'package:flutter/material.dart';

class VerifyButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const VerifyButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1BA39C),
              Color(0xFF148F77),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            "Verify",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}