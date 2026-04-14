import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class ResendOtp extends StatelessWidget {
  final VoidCallback onResend;
  final bool canResend;
  final int secondsRemaining;

  const ResendOtp({
    super.key,
    required this.onResend,
    required this.canResend,
    required this.secondsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            const TextSpan(
              text: "Didn't receive OTP? ",
              style: TextStyle(color: Colors.grey),
            ),

            canResend
                ? WidgetSpan(
              child: GestureDetector(
                onTap: onResend,
                child: const Text(
                  "Resend Code",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
                : TextSpan(
              text: "Resend in ${secondsRemaining}s",
              style: const TextStyle(
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}