class AppUser {
  final String id;
  final String email;
  final bool estadoPago;
  AppUser({required this.id, required this.email, required this.estadoPago});

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: '${j["id"]}',
    email: j["email"] ?? '',
    estadoPago: (j["estadoPago"] ?? j["paid"] ?? false) == true,
  );
}
