import 'package:flutter/material.dart';
import '../models/notificacion.dart';
import '../services/notificaciones_service.dart';

class NotificacionesScreen extends StatefulWidget {
  final String token;

  const NotificacionesScreen({super.key, required this.token});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  List<Notificacion> _notificaciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    try {
      final notis = await NotificacionesService.obtenerNotificaciones(widget.token);
      setState(() {
        _notificaciones = notis;
        _cargando = false;
      });
    } catch (e) {
      print('❌ Error al cargar notificaciones: $e');
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004AAD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔔 Notificaciones',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : _notificaciones.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay notificaciones aún',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _notificaciones.length,
                            separatorBuilder: (_, __) =>
                                const Divider(color: Colors.white30),
                            itemBuilder: (context, index) {
                              final n = _notificaciones[index];
                              return ListTile(
                                title: Text(
                                  n.titulo,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  n.cuerpo,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Text(
                                  n.fechaEnvio,
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
