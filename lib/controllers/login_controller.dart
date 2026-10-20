import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  bool get isPasswordObscured => _isPasswordObscured;

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
