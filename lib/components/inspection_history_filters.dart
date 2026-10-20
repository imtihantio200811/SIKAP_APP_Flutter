import 'package:flutter/material.dart';

import '../controllers/inspection_history_controller.dart';

class InspectionHistoryFilterChip extends StatelessWidget {
  const InspectionHistoryFilterChip({
    super.key,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = switch (index) {
      1 => const Color(0xFFFFD8D4),
      2 => const Color(0xFFFFDCA5),
      _ => const Color(0xFF082C50),
    };
    final foreground = index == 0 ? Colors.white : const Color(0xFF17283B);
    return SizedBox(
      height: 31,
      child: Material(
        color: selected ? background : background.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (index != 0) ...[
                    Icon(
                      index == 1 ? Icons.circle : Icons.info_outline,
                      size: 9,
                      color: index == 1
                          ? const Color(0xFFC51A20)
                          : const Color(0xFFAE741B),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      InspectionHistoryController.filters[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
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

class DigitalAwarenessBanner extends StatelessWidget {
  const DigitalAwarenessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFF103F68),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: const BoxDecoration(
              color: Color(0xFF315E83),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFF9DEBF2),
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KESADARAN DIGITAL',
                  style: TextStyle(
                    color: Color(0xFF8CE7EC),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '82% klaim yang diperiksa berhasil dicegah dari penyebaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
