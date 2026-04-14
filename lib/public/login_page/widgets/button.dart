import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginButton({
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
            colors: [Color(0xFF1BA39C), Color(0xFF148F77)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: (isLoading || onPressed == null) ? null : onPressed,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            "Login",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}