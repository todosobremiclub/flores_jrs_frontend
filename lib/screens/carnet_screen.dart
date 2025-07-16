import 'package:flutter/material.dart';
import '../models/socio.dart';

class CarnetScreen extends StatelessWidget {
  final Socio socio;

  const CarnetScreen({super.key, required this.socio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004AAD),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF002F6C),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Escudo y nombre del club
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/flores_jrs_logo.png', height: 40),
                      const SizedBox(width: 10),
                      const Text(
                        'Flores Jrs',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Foto del socio
                  if ((socio.foto ?? '').isNotEmpty)
                    ClipOval(
                      child: Image.network(
                        socio.foto!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const Icon(Icons.person, size: 100, color: Colors.white),

                  const SizedBox(height: 16),

                  // Nombre del socio
                  Text(
                    '${socio.nombre} ${socio.apellido}',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.yellow),
                  const SizedBox(height: 8),

                  // Campos con labels alineados
                  _filaDato('N° Socio', '${socio.numero}'),
                  _filaDato('Categoría', socio.categoria),
                  _filaDato('Nacimiento', socio.nacimiento?.substring(0, 4) ?? '—'),
                  _filaDato('Ingreso', socio.ingreso?.substring(0, 10) ?? '—'),

                  const SizedBox(height: 8),

                  // Último pago (mes + color)
                  Row(
                    children: [
                      const Text(
                        'Último pago',
                        style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Icon(Icons.circle, size: 12, color: socio.alDia ? Colors.green : Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        socio.ultimoPago ?? '—',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filaDato(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

