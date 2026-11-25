import 'package:dam_2026_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class AddObject extends StatefulWidget {
  const AddObject({super.key});

  @override
  State<AddObject> createState() => _AddObjectState();
}

class _AddObjectState extends State<AddObject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft, color: cTextoClaro),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: cFondo1,
        title:  Center(
          child: Text('Añadir Objeto', style: TextStyle(color: cTextoClaro, fontSize: 20, fontWeight: FontWeight.bold))),
      ),
      );
  }
}