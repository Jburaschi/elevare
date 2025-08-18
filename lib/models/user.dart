class User {
  final int id;
  final String nombre;
  final String email;
  final String role; // 'user' | 'admin'
  final bool estadoPago;

  User({required this.id, required this.nombre, required this.email, required this.role, required this.estadoPago});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
        nombre: json['nombre'] ?? '',
        email: json['email'] ?? '',
        role: (json['role'] ?? 'user').toString(),
        estadoPago: json['estadoPago'] == true || json['estadoPago'] == 1 || '${json['estadoPago']}' == 'true',
      );
}
