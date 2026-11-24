import 'package:dam_2026_project/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cFondo1,
        title: const Text('Extravíos USM'),
      ),
      body: const Center(
        child: Text('Bienvenido a la página de inicio'),
      ),
    );
  }
}