
class AppConfig {
  static const String appName = "Escuela Virtual de Modelaje";
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
