import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_2026_project/constants.dart';
import 'package:dam_2026_project/services/fs_service.dart';
import 'package:dam_2026_project/utils/format_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsObject extends StatelessWidget {
  const DetailsObject({super.key, required this.objeto});

  final QueryDocumentSnapshot objeto;

  @override
  Widget build(BuildContext context) {
    // Convierte el Timestamp de Firestore al formato de fecha de la aplicación.
    final fecha = formatearFecha(objeto['fecha']);

    return Scaffold(
      backgroundColor: cFondo2,
      appBar: AppBar(
        backgroundColor: cFondo1,
        iconTheme: IconThemeData(color: cTextoClaro),
        title: Text(
          'Detalles del objeto',
          style: TextStyle(color: cTextoClaro),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Image.network(
                    objeto['foto'],
                    fit: BoxFit.fill),
                ),
              SizedBox(height: 16),

              Text(
                objeto['titulo'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 12),
              Text(
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(objeto['descripcion']),
              SizedBox(height: 12),
              Row(children: [Text('Categoria: ', style: TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(objeto['categoria']))]),
              SizedBox(height: 12),
              Row(children: [Text('Lugar: ', style: TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(objeto['lugar']))]),
              SizedBox(height: 12),
              Row(children: [Text('Tipo: ', style: TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(objeto['tipo'] == true ? 'Encontrado' : 'Perdido'))]),
              SizedBox(height: 12),
              Row(children: [Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(objeto['estado'] == true ? 'Devuelto' : 'Vigente'))]),
              SizedBox(height: 12),
              Row(children: [Text('Fecha: ', style: TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(fecha))]),
              SizedBox(height: 12),
              Row(children: [Text('Autor: ', style: TextStyle(fontWeight: FontWeight.bold)), Expanded(child: Text(objeto['autor']))]),
              
              if (FirebaseAuth.instance.currentUser?.email == objeto['autor']) ...[
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: cPrimario,
                      foregroundColor: cTextoClaro
                    ),
                    icon: Icon(Icons.delete_outline),
                    label: Text('Eliminar objeto'),
                    onPressed: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          backgroundColor: cFondo2,
                          title: const Text('Retirar objeto'),
                          content: const Text(
                            '¿Seguro que quieres retirar el objeto?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: cPrimario,
                                foregroundColor: cTextoClaro
                              ),
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text('Retirar'),                         
                            ),
                          ],
                        ),
                      );
                      if (confirmar != true || !context.mounted) return;
                      try {
                        // Elimina el documento y vuelve a la lista actualizada.
                        await FsService().borrarObjeto(objeto.id);
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      } on FirebaseException catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'No se pudo eliminar el objeto: '
                              '${error.message ?? error.code}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  } 

  
}
