import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class NoticiaService {
  Future<List<Noticia>> obtenerNoticias(String token) async {
    try {
      print('🔑 Token usado en noticias: $token');

      final response = await http.get(
        Uri.parse('https://floresjrs.todosobremiclub.com.ar/noticias'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Noticia.fromJson(e)).toList();
      } else {
        print('❌ Error status: ${response.statusCode}');
        throw Exception('Error al obtener noticias');
      }
    } catch (e) {
      print('🚨 ERROR obtenerNoticias: $e');
      throw Exception('Error al obtener noticias');
    }
  }
}
