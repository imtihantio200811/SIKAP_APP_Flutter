import 'package:flutter/material.dart';

import '../controllers/inspection_history_controller.dart';
import '../models/inspection_history_item.dart';
import '../models/inspection_history_items.dart';
import 'inspection_history_card.dart';
import 'inspection_history_filters.dart';

class InspectionHistoryContent extends StatelessWidget {
  const InspectionHistoryContent({super.key, required this.controller});

  final InspectionHistoryController controller;

  @override
  Widget build(BuildContext context) {
    final query = controller.searchController.text.trim().toLowerCase();
    final filteredItems = inspectionHistoryItems.where((item) {
      final matchesText =
          query.isEmpty ||
          '${item.title} ${item.searchText}'.toLowerCase().contains(query);
      final matchesFilter = switch (controller.selectedFilterIndex) {
        1 => item.status == InspectionStatus.hoax,
        2 => item.status == InspectionStatus.contextNeeded,
        _ => true,
      };
      return matchesText && matchesFilter;
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 13, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 3),
          const Text(
            'Semua konten yang Anda pindai & simpan',
            style: TextStyle(
              color: Color(0xFF505763),
              fontSize: 12,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 15),
          _buildSearchRow(context),
          const SizedBox(height: 13),
          const DigitalAwarenessBanner(),
          const SizedBox(height: 15),
          _buildFilters(),
          const SizedBox(height: 11),
          if (filteredItems.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'Tidak ada riwayat yang cocok.',
                  style: TextStyle(color: Color(0xFF505763), fontSize: 13),
                ),
              ),
            )
          else
            ...filteredItems.map(_buildHistoryCard),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Riwayat Pemeriksaan',
            style: TextStyle(
              color: Color(0xFF0A2C50),
              fontSize: 20,
              height: 1.1,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: controller.clearSearchAndFilters,
          icon: const Icon(Icons.delete_outline, size: 13),
          label: const Text('Bersihkan'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF173958),
            backgroundColor: const Color(0xFFE6ECFF),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            minimumSize: const Size(0, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller.searchController,
              style: const TextStyle(color: Color(0xFF303746), fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF0F1FF),
                hintText: 'Cari klaim, isu, atau tautan...',
                hintStyle: const TextStyle(
                  color: Color(0xFF555C67),
                  fontSize: 12,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 19,
                  color: Color(0xFF414854),
                ),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: const Color(0xFFE9EDFF),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => controller.showFilters(context),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.tune, color: Color(0xFF173958), size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        for (
          var index = 0;
          index < InspectionHistoryController.filters.length;
          index++
        ) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            flex: index == 2 ? 3 : 2,
            child: InspectionHistoryFilterChip(
              index: index,
              selected: controller.selectedFilterIndex == index,
              onTap: () => controller.selectFilter(index),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHistoryCard(InspectionHistoryItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InspectionHistoryCard(
        title: item.title,
        time: item.time,
        method: item.method,
        trust: item.trust,
        status: item.status,
        thumbnailLabel: item.thumbnailLabel,
        thumbnailColor: item.thumbnailColor,
        thumbnailIcon: item.thumbnailIcon,
      ),
    );
  }
}
