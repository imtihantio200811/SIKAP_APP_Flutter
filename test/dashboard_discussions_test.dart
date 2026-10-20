import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/components/dashboard_discussions.dart';

void main() {
  testWidgets('DashboardDiscussions displays horizontal categories and discussion news cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DashboardDiscussions(),
          ),
        ),
      ),
    );

    // Section header
    expect(find.text('TOPIK DISKUSI'), findsOneWidget);
    expect(find.text('Geser kategori  ›'), findsOneWidget);

    // Initial categories (including added ones for horizontal scrolling)
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Pilkada'), findsOneWidget);
    expect(find.text('Kebijakan'), findsOneWidget);
    expect(find.text('Ekonomi'), findsOneWidget);

    // Discussion items displayed initially under 'Semua'
    expect(
      find.text(
        'KPU matangkan aturan debat publik paslon demi transparansi visi misi daerah',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Rancangan regulasi subsidi transportasi menuai respon beragam dari asosiasi warga',
      ),
      findsOneWidget,
    );

    // Scroll category list horizontally to find further categories
    final horizontalList = find.byType(ListView);
    expect(horizontalList, findsOneWidget);
    await tester.drag(horizontalList, const Offset(-300, 0));
    await tester.pumpAndSettle();

    expect(find.text('Teknologi'), findsOneWidget);
    expect(find.text('Pendidikan'), findsOneWidget);

    // Tap a specific category to filter
    await tester.tap(find.text('Teknologi'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Penyebaran hoaks berbasis AI deepfake meningkat, pakar dorong literasi verifikasi visual',
      ),
      findsOneWidget,
    );
    // Items not matching should be filtered out
    expect(
      find.text(
        'KPU matangkan aturan debat publik paslon demi transparansi visi misi daerah',
      ),
      findsNothing,
    );
  });
}
