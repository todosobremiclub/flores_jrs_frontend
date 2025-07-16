import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notificacion.dart';

class NotificacionesService {
  static Future<List<Notificacion>> obtenerNotificaciones(String token) async {
    if (token.isEmpty) throw Exception('Token no encontrado');

    final response = await http.get(
      Uri.parse('https://floresjrs.todosobremiclub.com.ar/notificaciones'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((n) => Notificacion.fromJson(n)).toList();
    } else {
      throw Exception('Error al obtener notificaciones');
    }
  }
}
