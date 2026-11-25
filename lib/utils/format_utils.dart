import 'package:cloud_firestore/cloud_firestore.dart';

String formatearFecha(dynamic valor) {
    final fecha = valor is Timestamp ? valor.toDate() : valor;
    if (fecha is DateTime) {
      final dia = fecha.day.toString().padLeft(2, '0');
      final mes = fecha.month.toString().padLeft(2, '0');
      final hora = fecha.hour.toString().padLeft(2, '0');
      final minuto = fecha.minute.toString().padLeft(2, '0');
      return '$dia/$mes/${fecha.year} $hora:$minuto';
    }
    return fecha?.toString() ?? 'Sin fecha';
  }