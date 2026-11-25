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
      backgroundColor: cFondo3,
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
      body: Container(
        decoration: BoxDecoration(
          color: cFondo2,
          borderRadius: BorderRadius.all(
            Radius.circular(16)
          ),
        ),
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        child: Form(       
          child:
            ListView(
              children:[
                TextFormField(
                  controller: tituloCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nombre del objeto',
                    border: OutlineInputBorder(),
                  )
                ),
                
                Divider(height: 16),
                TextFormField(
                  controller: lugarCtrl, 
                  decoration: InputDecoration(
                    labelText: 'Lugar',
                    border: OutlineInputBorder(),
                  )
                ),
                Divider(height: 16),
                
                TextFormField(
                  maxLines: 3,
                  controller: descripcionCtrl, 
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    hintText: 'Escriba una descripción breve.'
                  )
                ),
                Divider(height: 16),  
                Row(children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: cFondo1,
                      foregroundColor: cTextoClaro,
                    ),
                    onPressed: () async {
                      DateTime? fecha = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (fecha != null) {
                        setState(() {
                          fechaCtrl = fecha;
                        });
                      }
                    },
                    child: Text(fechaCtrl == null
                        ? 'Fecha de perdida'
                        : 'Fecha seleccionada: $fechaCtrl'),
                  ),
                Expanded(child: VerticalDivider(width: 16))
                ]
              )
            ],
          ),
        )
      )
    );
  }
}