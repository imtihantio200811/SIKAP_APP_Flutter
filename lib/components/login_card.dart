import 'package:flutter/material.dart';

import 'login_social_buttons.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(23, 21, 23, 24),
      decoration: BoxDecoration(
        color: const Color(0xFDFCFEFF),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFD4D7DB), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Username'),
          const SizedBox(height: 6),
          _InputField(
            controller: usernameController,
            hintText: 'Masukkan username akun',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 17),
          const _FieldLabel('Kata Sandi'),
          const SizedBox(height: 6),
          _InputField(
            controller: passwordController,
            hintText: 'Masukkan kata sandi akun',
            prefixIcon: Icons.lock_outline,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              splashRadius: 20,
              color: const Color(0xFF747B87),
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF123966),
                padding: const EdgeInsets.only(top: 9),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lupa Kata Sandi?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 49,
            child: FilledButton(
              onPressed: onLogin,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF123966),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Masuk ke SIKAP'),
                  SizedBox(width: 7),
                  Icon(Icons.arrow_forward, size: 19),
                ],
              ),
            ),
          ),
          const SizedBox(height: 23),
          const LoginSocialButtons(),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF172438),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 14, color: Color(0xFF242B38)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF858A96), fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF1F2FF),
          prefixIcon: Icon(
            prefixIcon,
            size: 19,
            color: const Color(0xFF747B87),
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF9BC9D1)),
          ),
        ),
      ),
    );
  }
}
