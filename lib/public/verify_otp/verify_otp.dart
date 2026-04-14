import 'dart:async';
import 'package:flutter/material.dart';
import '../reset_password/reset_password.dart';
import '../services/auth.dart';
import 'widgets/header.dart';
import 'widgets/input.dart';
import 'widgets/button.dart';
import 'widgets/resend.dart';

const Color primary = Color(0xFF1BA39C);

class VerifyOtpPage extends StatefulWidget {
  final String email;

  const VerifyOtpPage({super.key, required this.email});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  int _secondsRemaining = 30;
  bool _canResend = false;
  Timer? _timer;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : primary,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _canResend = false;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> _verifyOtp() async {
    String otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      _showMessage("Enter valid 6-digit OTP", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.verifyOtp(
      email: widget.email,
      otp: otp,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success']) {
      _showMessage(result['message']);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: widget.email),
        ),
      );
    } else {
      _showMessage(result['message'], isError: true);
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    final result = await _authService.sendOtp(email: widget.email);

    if (!mounted) return;

    _showMessage(result['message'], isError: !result['success']);

    if (result['success']) {
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  OtpHeader(email: widget.email),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primary),
                    ),
                    child: Column(
                      children: [
                        OtpInput(controllers: _controllers),

                        const SizedBox(height: 20),

                        VerifyButton(
                          isLoading: _isLoading,
                          onPressed: _verifyOtp,
                        ),

                        const SizedBox(height: 15),

                        ResendOtp(
                          onResend: _resendOtp,
                          canResend: _canResend,
                          secondsRemaining: _secondsRemaining,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 140),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copyright_rounded, size: 14, color: primary),
                      SizedBox(width: 5),
                      Text(
                        "Turing Tribes",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          letterSpacing: 1,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}