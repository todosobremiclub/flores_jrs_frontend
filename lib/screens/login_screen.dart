import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/socio.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();

  Future<void> _login() async {
    final numero = _numeroController.text.trim();
    final dni = _dniController.text.trim();

    if (numero.isEmpty || dni.isEmpty) {
      _mostrarError('Por favor ingrese número de socio y DNI');
      return;
    }

    final response = await http.post(
      Uri.parse('https://floresjrs.todosobremiclub.com.ar/socio/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numero': numero, 'dni': dni}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('🟢 Datos recibidos del backend: $data');

      final token = data['token'];
      final socio = Socio.fromJson(data['socio']);

      // ✅ Guardar token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('socioData', jsonEncode(socio.toJson()));
      print('✅ Token guardado: $token');

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(socio: socio, token: token)),
        );
      }
    } else {
      _mostrarError('Credenciales inválidas');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004AAD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/flores_jrs_logo.png', height: 80),
                const SizedBox(height: 24),
                const Text(
                  'Flores Juniors',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: _numeroController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Número de socio',
                    labelStyle: const TextStyle(color: Colors.yellow),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'DNI',
                    labelStyle: const TextStyle(color: Colors.yellow),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: const Color(0xFF002F6C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
