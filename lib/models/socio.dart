class Socio {
  final int numero;
  final String dni;
  final String nombre;
  final String apellido;
  final String categoria;
  final String? foto;
  final String? nacimiento;
  final String? ingreso;
  final bool activo;
  final bool becado;
  final String club;
  final bool alDia;
  final String? ultimoPago;

  Socio({
    required this.numero,
    required this.dni,
    required this.nombre,
    required this.apellido,
    required this.categoria,
    required this.foto,
    required this.nacimiento,
    required this.ingreso,
    required this.activo,
    required this.becado,
    required this.club,
    required this.alDia,
    required this.ultimoPago,
  });

  // ✅ Getter agregado
  String? get fechaNacimiento => nacimiento;

  factory Socio.fromJson(Map<String, dynamic> json) {
    return Socio(
      numero: json['numero'] ?? 0,
      dni: json['dni']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      categoria: json['categoria'] ?? '',
      foto: json['fotoUrl'] ?? '',
      nacimiento: json['nacimiento'] ?? '',
      ingreso: json['ingreso'] ?? '',
      activo: json['estado'] == 'Activo',
      becado: json['becado'] ?? false,
      club: json['club'] ?? '',
      ultimoPago: json['ultimoPago'] ?? '',
      alDia: json['alDia'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'dni': dni,
      'nombre': nombre,
      'apellido': apellido,
      'categoria': categoria,
      'fotoUrl': foto,
      'nacimiento': nacimiento,
      'ingreso': ingreso,
      'activo': activo,
      'becado': becado,
      'club': club,
      'alDia': alDia,
      'ultimoPago': ultimoPago,
    };
  }
}
