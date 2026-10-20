import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/components/dashboard_navigation.dart';

import 'support/test_app_helpers.dart';

void main() {
  testWidgets('follows login to the fact-check result popup', (
    WidgetTester tester,
  ) async {
    await pumpPhoneApp(tester);
    expect(find.text('Masuk ke SIKAP'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'admin123');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Masuk ke SIKAP'));
    await tester.pumpAndSettle();
    expect(find.text('LANGKAH 2 DARI 3'), findsOneWidget);
    await tester.ensureVisible(find.text('Lanjut'));
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Izin Hamparan Layar'), findsOneWidget);
    await tester.ensureVisible(find.text('Nanti Saja'));
    await tester.tap(find.text('Nanti Saja'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'Klaim politik yang perlu diperiksa berdasarkan data resmi.',
    );
    await tester.ensureVisible(find.text('Cek Instan'));
    await tester.tap(find.text('Cek Instan'));
    await tester.pump();
    expect(find.text('Memeriksa konten...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('Lencana SIKAP'), findsOneWidget);
    expect(find.text('Cenderung Fakta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('requires login fields before continuing', (
    WidgetTester tester,
  ) async {
    await pumpPhoneApp(tester);
    await tester.tap(find.text('Masuk ke SIKAP'));
    await tester.pumpAndSettle();
    expect(
      find.text('Masukkan username dan kata sandi untuk lanjut.'),
      findsOneWidget,
    );
    expect(find.text('LANGKAH 2 DARI 3'), findsNothing);
  });

  testWidgets('verifies a narrative link and opens the result popup', (
    WidgetTester tester,
  ) async {
    await pumpPhoneApp(tester);
    await tester.enterText(find.byType(TextField).at(0), 'admin123');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Masuk ke SIKAP'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Nanti Saja'));
    await tester.tap(find.text('Nanti Saja'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(DashboardNavigation),
        matching: find.byIcon(Icons.fact_check_outlined),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'Klaim politik yang perlu diperiksa berdasarkan data resmi.',
    );
    await tester.ensureVisible(find.text('Verifikasi Sekarang'));
    await tester.tap(find.text('Verifikasi Sekarang'));
    await tester.pump();
    expect(find.text('Memeriksa konten...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('Lencana SIKAP'), findsOneWidget);
    expect(find.text('Cenderung Fakta'), findsOneWidget);
  });

  testWidgets('bottom navigation opens the requested application frames', (
    WidgetTester tester,
  ) async {
    await pumpPhoneApp(tester);
    await tester.enterText(find.byType(TextField).at(0), 'admin123');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Masuk ke SIKAP'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Nanti Saja'));
    await tester.tap(find.text('Nanti Saja'));
    await tester.pumpAndSettle();

    expect(find.text('Berita & Pemantauan'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(DashboardNavigation),
        matching: find.byIcon(Icons.fact_check_outlined),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Deteksi Narasi & Manipulasi'), findsOneWidget);
    expect(find.text('Narasi dalam Pemantauan'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(DashboardNavigation),
        matching: find.byIcon(Icons.history),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Riwayat Pemeriksaan'), findsOneWidget);
    expect(
      find.text(
        'Foto antrean bantuan lama diklaim sebagai kondisi hari ini...',
      ),
      findsOneWidget,
    );
    await tester.tap(
      find.descendant(
        of: find.byType(DashboardNavigation),
        matching: find.byIcon(Icons.person_outline),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Profil Warga Digital'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(DashboardNavigation),
        matching: find.byIcon(Icons.home_filled),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Berita & Pemantauan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('scanner navigation leaves the host app open', (
    WidgetTester tester,
  ) async {
    const channel = MethodChannel('x-slayer/overlay_channel');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          return switch (call.method) {
            'isOverlayActive' => false,
            'checkPermission' => true,
            'showOverlay' => null,
            _ => null,
          };
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );
    await pumpPhoneApp(tester);
    await tester.enterText(find.byType(TextField).at(0), 'admin123');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Masuk ke SIKAP'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Nanti Saja'));
    await tester.tap(find.text('Nanti Saja'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(DashboardNavigation),
        matching: find.byIcon(Icons.document_scanner_outlined),
      ),
    );
    await tester.pump();
    expect(find.text('Berita & Pemantauan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
