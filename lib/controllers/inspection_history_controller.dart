import 'package:flutter/material.dart';

class InspectionHistoryController extends ChangeNotifier {
  InspectionHistoryController() {
    searchController.addListener(_handleSearchChanged);
  }

  final searchController = TextEditingController();

  static const filters = ['Semua (24)', 'Hoaks (15)', 'Butuh Konteks (6)'];

  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  void _handleSearchChanged() => notifyListeners();

  void selectFilter(int index) {
    if (_selectedFilterIndex == index) return;
    _selectedFilterIndex = index;
    notifyListeners();
  }

  void clearSearchAndFilters() {
    searchController.clear();
    _selectedFilterIndex = 0;
    notifyListeners();
  }

  void showFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter riwayat',
                style: TextStyle(
                  color: Color(0xFF0A2C50),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (var index = 0; index < filters.length; index++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(filters[index]),
                  trailing: _selectedFilterIndex == index
                      ? const Icon(Icons.check, color: Color(0xFF123966))
                      : null,
                  onTap: () {
                    selectFilter(index);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }
}
