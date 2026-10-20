import 'dart:ui';

import 'package:flutter/material.dart';

class DashboardNavigation extends StatelessWidget {
  const DashboardNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _icons = [
    Icons.home_filled,
    Icons.fact_check_outlined,
    Icons.document_scanner_outlined,
    Icons.history,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: const Color(0xD6DDEAF3),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0x99FFFFFF), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1C132E4A),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_icons.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onSelect(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: isSelected ? 54 : 40,
                  height: isSelected ? 54 : 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF123966)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Color(0x30102D4C),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    _icons[index],
                    size: isSelected ? 24 : 20,
                    color: isSelected ? Colors.white : const Color(0xFF173958),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
