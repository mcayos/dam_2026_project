
import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  Stream<QuerySnapshot> objetos() {
    return FirebaseFirestore.instance.collection('objetos').snapshots();
  }
  
  Future<void> agregarObjeto(String titulo, bool tipo, String lugar, String foto, DateTime fecha, String descripcion, String categoria, String autor) {
    return FirebaseFirestore.instance.collection('objetos').doc().set({
      'titulo': titulo,
      'tipo': tipo,                  // false: perdido, true: encontrado.
      'lugar': lugar,
      'foto': foto,
      'fecha': fecha,
      'estado': false,                // false: Vigente, true: Devuelto.
      'descripcion': descripcion,
      'categoria': categoria,
      'autor': autor,
    });
  }
  Future<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').orderBy('nombre').get();
  }

  Future<void> borrarObjeto(String id){
    return FirebaseFirestore.instance.collection('objetos').doc(id).delete();
  }
}

 