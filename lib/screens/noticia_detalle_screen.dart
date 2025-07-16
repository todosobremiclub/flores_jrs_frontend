import 'package:flutter/material.dart';
import '../models/noticia.dart';

class NoticiaDetalleScreen extends StatelessWidget {
  final Noticia noticia;

  const NoticiaDetalleScreen({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004AAD),
      appBar: AppBar(
        title: Text(
          noticia.titulo,
          style: const TextStyle(color: Colors.yellow),
        ),
        backgroundColor: const Color(0xFF002F6C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noticia.imagenUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  noticia.imagenUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'No se pudo cargar la imagen',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              noticia.texto,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

