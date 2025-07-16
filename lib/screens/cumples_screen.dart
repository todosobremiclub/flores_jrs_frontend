import 'package:flutter/material.dart';
import '../services/cumpleanios_service.dart';

class CumplesScreen extends StatefulWidget {
  const CumplesScreen({super.key});

  @override
  State<CumplesScreen> createState() => _CumplesScreenState();
}

class _CumplesScreenState extends State<CumplesScreen> {
  List<dynamic> cumpleanieros = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarCumples();
  }

  Future<void> cargarCumples() async {
    try {
      final cumpleaniosService = CumpleaniosService();
      final cumples = await cumpleaniosService.obtenerCumplesHoy();
      setState(() {
        cumpleanieros = cumples;
        cargando = false;
      });
    } catch (e) {
      print('❌ Exception: $e');
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004AAD),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : cumpleanieros.isEmpty
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '🎈 Hoy no hay cumpleaños',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🎈 Hoy cumplen años:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...cumpleanieros.map((socio) {
                              final tieneFoto = socio['foto_url'] != null && socio['foto_url'] != '';
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: tieneFoto
                                          ? NetworkImage(socio['foto_url'])
                                          : null,
                                      child: !tieneFoto
                                          ? const Icon(Icons.person, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${socio['nombre'] ?? ''} ${socio['apellido'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${socio['categoria'] ?? ''} – ${socio['edad'] ?? '?'} años',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
