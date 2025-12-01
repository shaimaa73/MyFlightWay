import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/login_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyFlightWayApp());
}

class MyFlightWayApp extends StatelessWidget {
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
      home: LoginScreen(),
    );
  }
}



// Home Page 
 


