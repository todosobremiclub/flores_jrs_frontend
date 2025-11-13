import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Notificación recibida en segundo plano: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

if (!kIsWeb) {
  // Primero solicitar permisos y esperar la respuesta del usuario
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  
  print('📋 Permisos de notificación: ${settings.authorizationStatus}');
  
  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    
    // En iOS, esperar a que el token APNS esté disponible
    String? fcmToken;
    try {
      // Para iOS, primero verificar si hay token APNS
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Dar tiempo a iOS para registrar el token APNS después de otorgar permisos
        await Future.delayed(const Duration(seconds: 2));
        
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        print('🍎 APNS Token obtenido: ${apnsToken != null ? "✓" : "✗"}');
        
        if (apnsToken != null) {
          fcmToken = await FirebaseMessaging.instance.getToken();
          print('🔑 FCM Token del dispositivo: $fcmToken');
        } else {
          print('⚠️ Token APNS no disponible, reintentando...');
          // Reintentar una vez más
          await Future.delayed(const Duration(seconds: 3));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          
          if (apnsToken != null) {
            fcmToken = await FirebaseMessaging.instance.getToken();
            print('🔑 FCM Token del dispositivo (2do intento): $fcmToken');
          } else {
            print('⚠️ Token APNS aún no disponible, usando listener');
            // Como último recurso, escuchar cuando el token esté disponible
            FirebaseMessaging.instance.onTokenRefresh.listen((token) {
              print('🔑 FCM Token del dispositivo (refresh): $token');
              FirebaseMessaging.instance.subscribeToTopic('todos');
              print('📌 Suscrito al tópico: todos (refresh)');
            });
          }
        }
      } else {
        // Para Android
        fcmToken = await FirebaseMessaging.instance.getToken();
        print('🔑 FCM Token del dispositivo: $fcmToken');
      }
      
      if (fcmToken != null) {
        // 👉 Suscripción al tópico 'todos'
        await FirebaseMessaging.instance.subscribeToTopic('todos');
        print('📌 Suscrito al tópico: todos');
      }
    } catch (e) {
      print('⚠️ Error al obtener FCM token: $e');
    }
  } else {
    print('❌ Permisos de notificación denegados');
  }
}


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flores Jrs',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF004AAD),
        fontFamily: 'Roboto',
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF002F6C),
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.white,
        ),
      ),
      home: const SplashDecisor(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashDecisor extends StatefulWidget {
  const SplashDecisor({super.key});

  @override
  State<SplashDecisor> createState() => _SplashDecisorState();
}

class _SplashDecisorState extends State<SplashDecisor> {
  @override
  void initState() {
    super.initState();
    _pedirPermisoNotificaciones();
    _verificarLogin();

    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📲 Notificación en primer plano: ${message.notification?.title}');
        if (message.notification != null) {
          final snackBar = SnackBar(
            content: Text(message.notification!.title ?? 'Notificación'),
            duration: const Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  Future<void> _pedirPermisoNotificaciones() async {
    if (!kIsWeb) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
    }
  }

Future<void> _verificarLogin() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  // Usar Future.delayed para esperar a que el build esté listo
  Future.delayed(Duration.zero, () {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
