
import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  Stream<QuerySnapshot> objetos() {
    return FirebaseFirestore.instance.collection('objetos').snapshots();
  }
}

 Future<void> agregarObjeto(String titulo, String lugar, String foto, DateTime fecha, String descripcion, String categoria, String autor) {
    return FirebaseFirestore.instance.collection('objetos').doc().set({
      'titulo': titulo,
      'tipo': false,                  // false: perdido, true: encontrado.
      'lugar': lugar,
      'foto': foto,
      'fecha': fecha,
      'estado': false,                // false: Vigente, true: Devuelto.
      'descripcion': descripcion,
      'categoria': categoria,
      'autor': autor,
    });
  }