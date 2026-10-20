import 'package:flutter/material.dart';

import 'demo_content_picker_sheet.dart';

class DashboardLinkChecker extends StatelessWidget {
  const DashboardLinkChecker({
    super.key,
    required this.controller,
    required this.onPaste,
    required this.onCheck,
    this.onSelectDemo,
  });

  final TextEditingController controller;
  final VoidCallback onPaste;
  final VoidCallback onCheck;
  final ValueChanged<String>? onSelectDemo;

  void _openDemoPicker(BuildContext context) {
    showDemoContentPickerModal(
      context,
      onSelected: (text) {
        controller.text = text;
        if (onSelectDemo != null) {
          onSelectDemo!(text);
        } else {
          onCheck();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF07858C), size: 19),
            const SizedBox(width: 5),
            const Expanded(
              child: Text(
                'AI Detektor Disinformasi',
                style: TextStyle(
                  color: Color(0xFF0A3159),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF9CEFF1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Instan 3.2s',
                style: TextStyle(
                  color: Color(0xFF09656D),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const Text(
          'Tempel tautan video TikTok, IG, cuitan, atau tulis rumor politik '
          'terkini untuk validasi data instan.',
          style: TextStyle(
            color: Color(0xFF555C67),
            fontSize: 12,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 48,
          padding: const EdgeInsets.only(left: 14, right: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F1FF),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Icon(Icons.link, size: 18, color: Color(0xFF737986)),
              const SizedBox(width: 7),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Color(0xFF303746),
                    fontSize: 12,
                  ),
                  decoration: const InputDecoration(
                    hintText:
                        'Tempel tautan video TikTok, IG, atau ketik rumor...',
                    hintStyle: TextStyle(
                      color: Color(0xFF828793),
                      fontSize: 12,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onPaste,
                icon: const Icon(Icons.content_paste, size: 14),
                label: const Text('Paste'),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFE2E7FF),
                  foregroundColor: const Color(0xFF424956),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Demo Pop-up Trigger
        InkWell(
          onTap: () => _openDemoPicker(context),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2EDF8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBACCE1)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, size: 12, color: Color(0xFF123966)),
                      SizedBox(width: 4),
                      Text(
                        'DEMO POP-UP',
                        style: TextStyle(
                          color: Color(0xFF123966),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                const Flexible(
                  child: Text(
                    'Pilih contoh konten demo terdaftar...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF123966),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.circle, color: Color(0xFF07858C), size: 9),
            const SizedBox(width: 7),
            const Expanded(
              child: Text(
                'Didukung 18 Arsip Resmi RI',
                style: TextStyle(
                  color: Color(0xFF454B56),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 43,
              child: FilledButton.icon(
                onPressed: onCheck,
                icon: const Icon(Icons.policy_outlined, size: 16),
                label: const Text('Cek Instan'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF123966),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
