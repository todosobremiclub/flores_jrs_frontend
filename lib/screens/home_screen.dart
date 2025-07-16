import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/socio.dart';
import 'carnet_screen.dart';
import 'noticias_screen.dart';
import 'notificaciones_screen.dart';
import 'cumples_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Socio socio;
  final String token;

  const HomeScreen({super.key, required this.socio, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      CarnetScreen(socio: widget.socio),
      NoticiasScreen(token: widget.token, socio: widget.socio),
      const CumplesScreen(),
      NotificacionesScreen(token: widget.token),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('socio');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004AAD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002F6C),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.yellow),
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF002F6C),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'Carnet'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Noticias'),
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: 'Cumples'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
        ],
      ),
    );
  }
}

