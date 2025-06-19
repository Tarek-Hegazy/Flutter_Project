import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'login.dart';
import 'register.dart';
import 'main-content.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();  // u3shan n3rf nst5dm shared preferences & API 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Box',
      // initialRoute: '/home',
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => MainScreen(), 
      },
    );
  }
}
