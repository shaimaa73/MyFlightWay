import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyFlightWayApp());
}

class MyFlightWayApp extends StatelessWidget {
  const MyFlightWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyFlightWay',
      theme: ThemeData(
        // ثيم الألوان
        primaryColor: const Color(0xFF26374D),
        scaffoldBackgroundColor: const Color(0xFFDDE6ED),
        fontFamily: 'Roboto', //  نوع الخط
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF9DB2BF)),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    await Future.delayed(const Duration(seconds: 1)); 
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      isLoggedIn = user != null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return isLoggedIn ? HomePage() : LoginScreen();
    }
  }
}


 


