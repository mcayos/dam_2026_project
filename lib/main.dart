import 'package:dam_2026_project/constants.dart';
import 'package:dam_2026_project/pages/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'USM Extravios',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: cSecundario),
      ),
      home: const AuthWrapper(),
    );
  }
}
