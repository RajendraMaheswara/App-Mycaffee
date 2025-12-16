import 'package:flutter/material.dart';
import 'pages/auth/login_pages.dart';
import 'pages/menu/menu_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyCaffee Admin',
      theme: ThemeData(
        primaryColor: const Color(0xFF5C4033),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C4033),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/menu': (_) => const MenuPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyCaffee Admin'),
        backgroundColor: const Color(0xFF5C4033),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.coffee, size: 100, color: Color(0xFF5C4033)),
            const SizedBox(height: 20),
            const Text(
              'MyCaffee Admin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C4033),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Kelola menu kafe Anda'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C4033),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Kelola Menu',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}