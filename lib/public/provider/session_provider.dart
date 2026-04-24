import 'dart:async';
import 'package:flutter/material.dart';
import '../services/session.dart';

class SessionProvider extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  String? role;
  String? department;
  String? phone;

  bool isLoading = true;
  bool isInactive = false;
  String inactiveReason = "";

  Timer? _sessionTimer;

  Future<void> init() async {
    final user = await _sessionService.getStoredUser();

    role = user['role'];
    department = user['department'];
    phone = user['phone'];

    if (role == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    await _validateSession();

    _sessionTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _validateSession();
    });

    isLoading = false;
    notifyListeners();
  }

  Future<void> _validateSession() async {
    if (phone == null) return;

    final result = await _sessionService.validateUser(phone!);

    if (!result['success']) return;

    if (!result['isActive']) {
      inactiveReason = result['reason'] ?? "Account deactivated";
      isInactive = true;
      await _sessionService.clearSession();
      notifyListeners();
    }
  }

  void disposeTimer() {
    _sessionTimer?.cancel();
  }

  @override
  void dispose() {
    disposeTimer();
    super.dispose();
  }
}