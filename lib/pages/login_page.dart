import 'package:flutter/material.dart';

import '../components/login_backdrop.dart';
import '../components/login_card.dart';
import '../components/platform_badge.dart';
import '../components/local_login_info_prompt.dart';
import '../components/sikap_brand.dart';
import '../components/verification_footer.dart';
import '../components/version_badge.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    required this.controller,
    required this.onLogin,
    required this.onLocalLoginInfo,
  });

  final LoginController controller;
  final VoidCallback onLogin;
  final VoidCallback onLocalLoginInfo;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  const Positioned.fill(child: LoginBackdrop()),
                  Center(
                    child: SizedBox(
                      width: constraints.maxWidth < 402
                          ? constraints.maxWidth
                          : 402,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.viewInsetsOf(context).bottom,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                const SizedBox(height: 30),
                                const PlatformBadge(),
                                const SizedBox(height: 12),
                                const SikapBrand(),
                                const SizedBox(height: 8),
                                const Text(
                                  'Kawal Demokrasi Bersih & Terverifikasi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF4D535D),
                                    fontSize: 15,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                const VersionBadge(),
                                const SizedBox(height: 24),
                                LoginCard(
                                  usernameController:
                                      controller.usernameController,
                                  passwordController:
                                      controller.passwordController,
                                  obscurePassword:
                                      controller.isPasswordObscured,
                                  onTogglePassword:
                                      controller.togglePasswordVisibility,
                                  onLogin: onLogin,
                                ),
                                const SizedBox(height: 17),
                                LocalLoginInfoPrompt(
                                  onPressed: onLocalLoginInfo,
                                ),
                                const SizedBox(height: 34),
                                const VerificationFooter(),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
