import 'package:flutter/material.dart';
import 'package:flutter_application_1/splashScreen.dart';
import 'login.dart';
import 'register.dart';
import 'main-content.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/home': (context) =>
            MainScreen(), 
      },
    );
  }
}
