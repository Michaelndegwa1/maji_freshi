import 'package:flutter/material.dart';
import 'package:maji_freshi/screens/splash_screen.dart';
import 'package:maji_freshi/utils/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TODO: Remove this after first run
  // await _migrateData();

  runApp(const MyApp());
}

// Temporary migration function
/*
import 'package:maji_freshi/data/product_data.dart';
import 'package:maji_freshi/services/database_service.dart';

Future<void> _migrateData() async {
  final db = DatabaseService();
  for (var product in ProductData.products) {
    await db.uploadProduct(product);
    print('Uploaded: ${product.title}');
  }
}
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maji Fresh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
