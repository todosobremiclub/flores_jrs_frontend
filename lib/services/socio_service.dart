import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/socio.dart';

const String baseUrl = 'https://floresjrs.todosobremiclub.com.ar';

class SocioService {
  Future<Map<String, dynamic>?> obtenerSocioConToken(String numero, String dni) async {
    final url = Uri.parse('$baseUrl/socio/login');
    final body = json.encode({
      'numero': numero,
      'dni': dni,
    });

    print('📤 Enviando login a: $url');
    print('📦 Body: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('🔁 Código de respuesta: ${response.statusCode}');
    print('📨 Respuesta body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final socio = Socio.fromJson(data['socio']);
      return {
        'socio': socio,
        'token': data['token'],
      };
    } else {
      return null;
    }
  }
}





