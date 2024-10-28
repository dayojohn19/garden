import 'package:flutter/material.dart';
import 'package:app/pages/loading.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/my_collection.dart';
import 'package:app/pages/scan_code.dart';
import 'package:app/pages/scan_result.dart';
import 'package:app/pages/scan_loading.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/collection': (context) => const MyCollection(),
        '/scan': (context) => const QRScanner(),
        '/scan_loading': (context) => const ScanLoading(),
        '/scan_result': (context) => const ScanResult(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
