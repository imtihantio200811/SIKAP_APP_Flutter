import 'package:flutter/material.dart';

import '../models/inspection_history_item.dart';
import 'inspection_history_thumbnail.dart';

class InspectionHistoryCard extends StatelessWidget {
  const InspectionHistoryCard({
    super.key,
    required this.title,
    required this.time,
    required this.method,
    required this.trust,
    required this.status,
    required this.thumbnailLabel,
    required this.thumbnailColor,
    required this.thumbnailIcon,
  });

  final String title;
  final String time;
  final String method;
  final int trust;
  final InspectionStatus status;
  final String thumbnailLabel;
  final Color thumbnailColor;
  final IconData thumbnailIcon;

  Color get _statusColor => switch (status) {
    InspectionStatus.hoax => const Color(0xFFD21F24),
    InspectionStatus.valid => const Color(0xFF00828A),
    InspectionStatus.contextNeeded => const Color(0xFFB27711),
  };

  Color get _statusBackground => switch (status) {
    InspectionStatus.hoax => const Color(0xFFFFD8D4),
    InspectionStatus.valid => const Color(0xFFA8F0F2),
    InspectionStatus.contextNeeded => const Color(0xFFFFDCA5),
  };

  String get _statusText => switch (status) {
    InspectionStatus.hoax => 'HOAKS',
    InspectionStatus.valid => 'FAKTA VALID',
    InspectionStatus.contextNeeded => 'BUTUH KONTEKS',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10162E48),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InspectionHistoryThumbnail(
                label: thumbnailLabel,
                color: thumbnailColor,
                icon: thumbnailIcon,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  status == InspectionStatus.hoax
                                      ? Icons.cancel_outlined
                                      : status == InspectionStatus.valid
                                      ? Icons.verified_outlined
                                      : Icons.info_outline,
                                  size: 11,
                                  color: _statusColor,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    _statusText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _statusColor,
                                      fontSize: 10,
                                      height: 1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF444B57),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF0A2C50),
                        fontSize: 16,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          status == InspectionStatus.valid
                              ? Icons.link
                              : status == InspectionStatus.contextNeeded
                              ? Icons.graphic_eq
                              : Icons.shield_outlined,
                          color: const Color(0xFF00818A),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            method,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF4F5662),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FD),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 112,
                  child: Text(
                    'Tingkat Kepercayaan:',
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFF414854),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: trust / 100,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFDCE3FF),
                      color: _statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  '$trust%',
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 13),
                const Icon(
                  Icons.share_outlined,
                  color: Color(0xFF414854),
                  size: 17,
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF123966),
                  size: 19,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
