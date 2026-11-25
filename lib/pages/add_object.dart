import 'package:dam_2026_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class AddObject extends StatefulWidget {
  const AddObject({super.key});
  
  @override
  State<AddObject> createState() => _AddObjectState();
}

class _AddObjectState extends State<AddObject> {
  final tituloCtrl = TextEditingController(); 
  final descripcionCtrl = TextEditingController();
  // tipo por defecto en perdido.
  String? categoriaCtrl;
  final lugarCtrl = TextEditingController();
  DateTime? fechaCtrl;
  final fotoCtrl = TextEditingController();
  // estado por defecto en vigente.
  User? user;

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
        title:  Text('Publicando objeto extraviado', style: TextStyle(color: cTextoClaro, fontSize: 20, fontWeight: FontWeight.bold)),

      ),
      body: Form(       
        child:
            ListView(
              children:[
                TextFormField(
                  controller: tituloCtrl, 
                  decoration: InputDecoration(
                    labelText: 'Título del objeto',
                    hintText: 'Título del objeto'
                  )
                ),
                TextFormField(
                  controller: descripcionCtrl, 
                  decoration: InputDecoration(
                    labelText: 'Descripción del objeto',
                    hintText: 'Descripción del objeto'
                  )
                ),
                TextFormField(
                  controller: lugarCtrl, 
                  decoration: InputDecoration(
                    labelText: 'Lugar donde se perdió',
                    hintText: 'Lugar donde se perdió'
                  )
                ),

              ]
              ),
        ),
      );
  }
}