import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maji_freshi/main.dart';
import 'package:maji_freshi/screens/splash_screen.dart';

class FakeAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    // Return a 1x1 transparent PNG
    final Uint8List transparentImage = Uint8List.fromList(<int>[
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82,
    ]);
    return ByteData.view(transparentImage.buffer);
  }

  @override
  Future<T> loadStructuredData<T>(
      String key, Future<T> Function(String value) parser) async {
    return parser('');
  }
}

void main() {
  testWidgets('App starts with Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: FakeAssetBundle(),
        child: const MyApp(),
      ),
    );

    // Verify that the Splash Screen is displayed.
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Maji Fresh'), findsOneWidget);
  });
}
