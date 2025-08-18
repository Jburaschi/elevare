
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/content_provider.dart';
import 'screens/landing.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/admin.dart';
import 'screens/profile.dart';
import 'screens/video.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
      ],
      child: MaterialApp.router(
        title: 'Escuela Virtual de Modelaje',
        theme: appDarkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (_, __) => kIsWeb ? '/landing' : '/login'),
    GoRoute(path: '/landing', builder: (_, __) => const LandingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/admin', builder: (ctx, __) {
      final auth = ctx.read<AuthProvider>();
      if (!auth.isAdmin) return const LoginScreen();
      return const AdminScreen();
    }),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/video/:id', builder: (ctx, st) {
      final idStr = st.pathParameters['id'] ?? '0';
      final id = int.tryParse(idStr) ?? 0;
      return VideoScreen(id: id);
    }),
  ],
);
