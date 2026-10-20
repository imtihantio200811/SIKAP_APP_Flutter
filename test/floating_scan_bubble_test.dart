import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/components/floating_scan_bubble.dart';
import 'package:sikap_project/models/fact_check_result.dart';

import 'support/test_app_helpers.dart';

void main() {
  testWidgets('bubble shows loading and simulated fact-check result on tap', (
    WidgetTester tester,
  ) async {
    mockOverlayResize();
    await tester.pumpWidget(const FloatingScanBubble());
    expect(find.bySemanticsLabel('Buka pemindai SIKAP'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      ),
      findsOneWidget,
    );
    await tester.tap(find.bySemanticsLabel('Buka pemindai SIKAP'));
    await tester.pump();
    expect(find.text('Memeriksa konten...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1999));
    expect(find.text('Memeriksa konten...'), findsOneWidget);
    expect(
      find.text('SIKAP sedang menilai klaim dan sumbernya'),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();
    expect(find.text('Lencana SIKAP'), findsOneWidget);
    expect(find.text('Terindikasi Hoaks'), findsOneWidget);
    expect(find.text('94% yakin'), findsOneWidget);
    expect(find.text('Detail Fakta'), findsOneWidget);
    await tester.tap(find.text('Detail Fakta'));
    await tester.pump();
    expect(
      find.textContaining('Pemeriksaan forensik spektrogram audio'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('bubble opens a previously analyzed result when tapped', (
    WidgetTester tester,
  ) async {
    mockOverlayResize();
    final messageController = StreamController<Object?>.broadcast();
    addTearDown(messageController.close);
    await tester.pumpWidget(
      FloatingScanBubble(messageStream: messageController.stream),
    );
    messageController.add(
      const FactCheckResult(
        verdict: FactCheckVerdict.falseClaim,
        isPolitical: true,
        claim: 'Klaim politik yang diperiksa.',
        summary: 'Bukti yang tersedia membantah klaim ini.',
        explanation: 'Sumber primer tidak mendukung klaim tersebut.',
        confidence: 90,
        sources: [],
      ).toMap(),
    );
    await tester.pump();
    expect(find.bySemanticsLabel('Buka pemindai SIKAP'), findsNothing);
    expect(find.text('Lencana SIKAP'), findsOneWidget);
    expect(find.text('Terindikasi Hoaks'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bubble shows scan loading and complete fact details', (
    WidgetTester tester,
  ) async {
    mockOverlayResize();
    final messageController = StreamController<Object?>.broadcast();
    addTearDown(messageController.close);
    await tester.pumpWidget(
      FloatingScanBubble(messageStream: messageController.stream),
    );
    messageController.add({'type': 'scan_loading'});
    await tester.pump();
    expect(find.text('Memeriksa konten...'), findsOneWidget);
    messageController.add(
      const FactCheckResult(
        verdict: FactCheckVerdict.uncertain,
        isPolitical: true,
        claim: 'Klaim politik yang dibagikan.',
        summary: 'Klaim belum didukung sumber yang cukup.',
        explanation: 'Periksa dokumen primer dan tanggal sumber.',
        confidence: 68,
        sources: [
          FactCheckSource(
            title: 'Arsip resmi',
            url: 'https://example.com/arsip',
          ),
        ],
      ).toMap(),
    );
    await tester.pump();
    expect(find.text('Memeriksa konten...'), findsNothing);
    expect(find.text('Lencana SIKAP'), findsOneWidget);
    expect(find.text('Belum Terverifikasi'), findsOneWidget);
    expect(find.text('68% yakin'), findsOneWidget);
    await tester.tap(find.text('Detail Fakta'));
    await tester.pump();
    expect(find.text('Klaim yang dibagikan'), findsOneWidget);
    expect(find.text('Klaim politik yang dibagikan.'), findsOneWidget);
    expect(find.text('Penjelasan'), findsOneWidget);
    expect(
      find.text('Periksa dokumen primer dan tanggal sumber.'),
      findsOneWidget,
    );
    expect(find.text('Keyakinan model: 68%'), findsOneWidget);
    expect(find.text('Arsip resmi'), findsOneWidget);
    expect(find.text('https://example.com/arsip'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bubble close button dismisses landscape result back to bubble', (
    WidgetTester tester,
  ) async {
    mockOverlayResize();
    final messageController = StreamController<Object?>.broadcast();
    addTearDown(messageController.close);
    await tester.pumpWidget(
      FloatingScanBubble(messageStream: messageController.stream),
    );
    messageController.add(
      const FactCheckResult(
        verdict: FactCheckVerdict.verifiedTrue,
        isPolitical: true,
        claim: 'Klaim berita.',
        summary: 'Klaim sesuai rujukan.',
        explanation: 'Fakta valid.',
        confidence: 95,
        sources: [],
      ).toMap(),
    );
    await tester.pump();

    expect(find.text('Lencana SIKAP'), findsOneWidget);
    expect(find.text('Cenderung Fakta'), findsOneWidget);
    expect(find.text('95% yakin'), findsOneWidget);
    expect(find.text('Klaim sesuai rujukan.'), findsOneWidget);
    expect(find.text('Detail Fakta'), findsOneWidget);

    await tester.tap(find.byTooltip('Tutup hasil'));
    await tester.pump();

    expect(find.bySemanticsLabel('Buka pemindai SIKAP'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
