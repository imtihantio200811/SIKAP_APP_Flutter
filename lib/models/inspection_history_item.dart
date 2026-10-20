import 'package:flutter/material.dart';

enum InspectionStatus { hoax, valid, contextNeeded }

class InspectionHistoryItem {
  const InspectionHistoryItem({
    required this.title,
    required this.time,
    required this.method,
    required this.trust,
    required this.status,
    required this.thumbnailLabel,
    required this.thumbnailColor,
    required this.thumbnailIcon,
    required this.searchText,
  });

  final String title;
  final String time;
  final String method;
  final int trust;
  final InspectionStatus status;
  final String thumbnailLabel;
  final Color thumbnailColor;
  final IconData thumbnailIcon;
  final String searchText;
}
