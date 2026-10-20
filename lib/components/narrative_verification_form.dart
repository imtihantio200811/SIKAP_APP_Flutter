import 'package:flutter/material.dart';

import 'demo_content_picker_sheet.dart';

class NarrativeVerificationForm extends StatelessWidget {
  const NarrativeVerificationForm({
    super.key,
    required this.controller,
    required this.isAnalyzing,
    required this.onPaste,
    required this.onVerify,
    this.onSelectDemo,
  });

  final TextEditingController controller;
  final bool isAnalyzing;
  final VoidCallback onPaste;
  final VoidCallback onVerify;
  final ValueChanged<String>? onSelectDemo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C18324E),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.link, size: 16, color: Color(0xFF007A82)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Tautan atau Teks Klaim Politik',
                  style: TextStyle(
                    color: Color(0xFF143354),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F1F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 7, color: Color(0xFF007A82)),
                    SizedBox(width: 4),
                    Text(
                      'Ready to Scan',
                      style: TextStyle(
                        color: Color(0xFF00717A),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Container(
            height: 42,
            padding: const EdgeInsets.only(left: 11, right: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.travel_explore,
                  size: 17,
                  color: Color(0xFF777D89),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: Color(0xFF242C3B),
                      fontSize: 12,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'Tautan HTTPS atau teks klaim (min. 40 karakter)',
                      hintStyle: TextStyle(
                        color: Color(0xFF353B47),
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
                  icon: const Icon(Icons.content_paste, size: 13),
                  label: const Text('Tempel'),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE3E8FF),
                    foregroundColor: const Color(0xFF263750),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 29),
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
          InkWell(
            onTap: () {
              showDemoContentPickerModal(
                context,
                onSelected: (text) {
                  controller.text = text;
                  if (onSelectDemo != null) {
                    onSelectDemo!(text);
                  } else {
                    onVerify();
                  }
                },
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
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
                        Icon(
                          Icons.touch_app,
                          size: 12,
                          color: Color(0xFF123966),
                        ),
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
                  const Expanded(
                    child: Text(
                      'Pilih contoh narasi demo terdaftar...',
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
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Pemeriksaan file audio/video belum tersedia. Saat ini SIKAP '
              'menganalisis teks dan konteks tautan.',
              style: TextStyle(
                color: Color(0xFF73520A),
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: isAnalyzing ? null : onVerify,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF123966),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF58718C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 3,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAnalyzing)
                    const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(Icons.auto_awesome, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      isAnalyzing ? 'Memverifikasi...' : 'Verifikasi Sekarang',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isAnalyzing) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
