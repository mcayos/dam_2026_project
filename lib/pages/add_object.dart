import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_2026_project/constants.dart';
import 'package:dam_2026_project/services/auth_service.dart';
import 'package:dam_2026_project/services/fs_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class AddObject extends StatefulWidget {
  const AddObject({super.key});
  
  @override
  State<AddObject> createState() => _AddObjectState();
}

class _AddObjectState extends State<AddObject> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tituloCtrl = TextEditingController(); 
  TextEditingController descripcionCtrl = TextEditingController();
  // tipo por defecto en perdido.
  bool tipo = false;
  String? categoriaCtrl;
  TextEditingController lugarCtrl = TextEditingController();
  DateTime? fechaCtrl;
  TextEditingController fotoCtrl = TextEditingController();
  late final Future<QuerySnapshot> categoriasFuture;
  // estado por defecto en vigente.
  User? user;
  
  @override
  void initState() {
    super.initState();
    categoriasFuture = FsService().categorias();
    AuthService().currentUser().then((currentU) {
      if (!mounted) return;
      setState(() {
        user = currentU;
      });
    });
  }
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
          key: formKey,    
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
                DropdownButtonFormField<bool>(
                  value: tipo,
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Perdido'),
                    ),
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Encontrado'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      tipo = value;
                    });
                  },
                ),
                Divider(height: 16),
                FutureBuilder(
                    future: categoriasFuture,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Cargando categorías...');
                      }
                      var categorias = snapshot.data!.docs;
                      return DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: categoriaCtrl ?? 'Categoría',
                          border: OutlineInputBorder(),
                        ),
                        items: categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria['nombre'].toString(),
                            child: Text(categoria['nombre']),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'Seleccione una categoría' : null,
                        onChanged: (value) {
                          setState(() {
                            categoriaCtrl = value;
                          });
                        },
                        
                      );
                  },
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
                
                
                Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Seleccione una foto:'),
                    IconButton(
                      icon: Icon(MdiIcons.camera),
                      onPressed: () {
                        // Lógica para seleccionar una foto desde camara
                      },
                    ),
                    IconButton(
                      icon: Icon(MdiIcons.folderImage),
                      onPressed: () {
                        // Lógica para seleccionar una foto desde galeria
                      },
                    ),
                    IconButton(
                      icon: Icon(MdiIcons.web),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Ingrese la URL de la foto'),
                              content: TextField(
                                controller: fotoCtrl,
                                decoration: InputDecoration(
                                  hintText: 'https://ejemplo.com/foto.jpg',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                        // Lógica para seleccionar una foto desde galeria
                      },
                    )
                  ]
                ),
                Divider(height: 16),
                Text(fotoCtrl.text.isEmpty ? 'No se ha seleccionado ninguna foto' : 'Foto seleccionada desde URL:\n ${fotoCtrl.text}'),          
                Divider(height: 16),
                Text('Autor: ${user?.email ?? 'Anónimo'}'),
              ],
          ),
        )
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        if (!(formKey.currentState?.validate() ?? false)) return;

        final fecha = fechaCtrl;
        if (fecha == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Seleccione una fecha de pérdida')),
          );
          return;
        }

        final categoria = categoriaCtrl;
        if (categoria == null) return;

        try {
          await FsService().agregarObjeto(
            tituloCtrl.text,
            tipo,
            lugarCtrl.text,
            fotoCtrl.text,
            fecha,
            descripcionCtrl.text,
            categoria,
            user?.email ?? 'Anónimo',
          );

          if (!mounted) return;
          Navigator.pop(context);
        } on FirebaseException catch (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No se pudo guardar el objeto: ${error.message ?? error.code}',
              ),
            ),
          );
        }
      },
      backgroundColor: cFondo1,
      child: Icon(MdiIcons.cloudArrowUpOutline, color: cTextoClaro)
    ),
    );
  }
}