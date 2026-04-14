import 'package:flutter/material.dart';
import 'field.dart';

const Color primary = Color(0xFF1BA39C);

class ForgotForm extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSendOtp;
  final VoidCallback onBackToLogin;
  final bool isEmailValid;

  const ForgotForm({
    super.key,
    required this.emailController,
    required this.isLoading,
    required this.onSendOtp,
    required this.onBackToLogin,
    required this.isEmailValid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primary, width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                gradient: isEmailValid
                    ? const LinearGradient(
                  colors: [
                    Color(0xFF1BA39C),
                    Color(0xFF148F77),
                  ],
                )
                    : null,
                color: isEmailValid ? null : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),

                onPressed: (!isEmailValid || isLoading)
                    ? null
                    : onSendOtp,

                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  "Send OTP",
                  style: TextStyle(
                    color: isEmailValid
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Center(
            child: GestureDetector(
              onTap: onBackToLogin,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12),
                  children: [
                    TextSpan(
                      text: "Remember your password? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "Log in",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}