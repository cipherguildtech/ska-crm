import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  bool _isCompletedSelected = false;

  bool get isCompletedSelected => _isCompletedSelected;

  void setCompleted(bool value) {
    _isCompletedSelected = value;
    notifyListeners();
  }

  void toggleCompleted() {
    _isCompletedSelected = !_isCompletedSelected;
    notifyListeners();
  }
}
