import 'package:flutter/material.dart';

class SikapBrand extends StatelessWidget {
  const SikapBrand({
    super.key,
    this.height = 130,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/sikap_logo.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}

