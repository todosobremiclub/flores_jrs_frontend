import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CumpleaniosService {
  Future<List<dynamic>> obtenerCumplesHoy() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('🔑 Token cargado desde SharedPreferences: $token');

    final response = await http.get(
      Uri.parse('https://floresjrs.todosobremiclub.com.ar/cumpleanios/hoy'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cumpleanios'] ?? [];
    } else {
      print('❌ Error statusCode: ${response.statusCode}');
      throw Exception('Error al cargar cumpleaños');
    }
  }
}
