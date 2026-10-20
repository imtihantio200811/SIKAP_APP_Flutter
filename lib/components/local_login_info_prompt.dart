import 'package:flutter/material.dart';

class LocalLoginInfoPrompt extends StatelessWidget {
  const LocalLoginInfoPrompt({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Login demo lokal: ',
          style: TextStyle(color: Color(0xFF5C616B), fontSize: 14),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: const Color(0xFF123966),
          ),
          child: const Text('Lihat kredensial', style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
