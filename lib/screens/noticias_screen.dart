import 'package:flutter/material.dart';
import '../models/noticia.dart';
import '../models/socio.dart';
import '../services/noticias_service.dart';
import 'noticia_detalle_screen.dart';

class NoticiasScreen extends StatefulWidget {
  final String token;
  final Socio socio;

  const NoticiasScreen({super.key, required this.token, required this.socio});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  late Future<List<Noticia>> _futuroNoticias;

  @override
  void initState() {
    super.initState();
    _futuroNoticias = _filtrarNoticiasPorSocio();
  }

  Future<List<Noticia>> _filtrarNoticiasPorSocio() async {
    final todas = await NoticiaService().obtenerNoticias(widget.token);

    final categoriaSocio = widget.socio.categoria.toLowerCase() ?? '';
    final anioSocio = widget.socio.fechaNacimiento?.substring(0, 4) ?? '';

    return todas.where((n) {
      if (n.destino == 'todos') return true;

      if (n.destino == 'categoria') {
        return n.categoria
                ?.toLowerCase()
                .split(',')
                .contains(categoriaSocio) ??
            false;
      }

      if (n.destino == 'categoria_anio') {
        return (n.categoria
                    ?.toLowerCase()
                    .split(',')
                    .contains(categoriaSocio) ??
                false) &&
            n.anio == anioSocio;
      }

      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004AAD),
      body: SafeArea(
        child: FutureBuilder<List<Noticia>>(
          future: _futuroNoticias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No hay noticias disponibles.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            final noticias = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            NoticiaDetalleScreen(noticia: noticia),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.blue[900],
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: noticia.imagenUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                noticia.imagenUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.article, color: Colors.white),
                      title: Text(
                        noticia.titulo,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

