class Noticia {
  final int id;
  final String titulo;
  final String texto;
  final String? imagenUrl;
  final String? categoria;
  final String? anio;
  final String? fecha;
  final String? destino; // 👈 necesario para filtrar noticias

  Noticia({
    required this.id,
    required this.titulo,
    required this.texto,
    this.imagenUrl,
    this.categoria,
    this.anio,
    this.fecha,
    this.destino,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      texto: json['texto'] ?? '',
      imagenUrl: json['imagen_url'],
      categoria: json['categoria'],
      anio: json['anio_nacimiento'], // ✅ corregido
      fecha: json['fecha'],
      destino: json['destino'],      // ✅ necesario para filtrar
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'texto': texto,
      'imagen_url': imagenUrl,
      'categoria': categoria,
      'anio_nacimiento': anio,
      'fecha': fecha,
      'destino': destino,
    };
  }
}
