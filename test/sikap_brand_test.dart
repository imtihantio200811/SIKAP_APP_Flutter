import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/components/sikap_brand.dart';

void main() {
  testWidgets('SikapBrand renders the official sikap_logo asset', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SikapBrand(),
          ),
        ),
      ),
    );

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final imageWidget = tester.widget<Image>(imageFinder);
    expect(imageWidget.image, isA<AssetImage>());
    final assetImage = imageWidget.image as AssetImage;
    expect(assetImage.assetName, 'assets/sikap_logo.png');
  });
}
