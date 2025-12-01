import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';

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

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo 
              Image.asset(
                'images/myLogo.png',
                width: 400,   // حجم الصورة 
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 1),

              //  Email Field 
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Color(0xFF9DB2BF)),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Color(0xFF536D82)),
                  prefixIcon:
                      const Icon(Icons.email, color: Color(0xFF9DB2BF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF9DB2BF)),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Color(0xFF536D82)),
                  prefixIcon:
                      const Icon(Icons.lock, color: Color(0xFF9DB2BF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              //  Login Button 
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                 onPressed: () {
  // عرض رسالة النجاح 
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Login successful!"),
      backgroundColor: Color(0xFF536D82),
      duration: Duration(seconds: 1), // مدة عرض الرسالة
    ),
  );

  // الانتظار قبل التنقل عشان المستخدم يشوف الرسالة
  Future.delayed(const Duration(seconds: 1), () {
   Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomePage()),
);
  });
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9DB2BF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF26374D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // \ Sign Up Text 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Color(0xFF536D82)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xFF9DB2BF)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Home Page 
 


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0; // تحديد الصفحة الحالية

  // الصفحات 
  final List<Widget> _pages = [
  const HomePageScreen(),
  const SearchPageScreen(),
  const ProfilePageScreen(),
  const SettingsPageScreen(),
];

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF536D82),
        elevation: 4,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/Logomini.png', 
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
            },
          ),
        ],
      ),

      //  Body 
body: Container(
  color: Colors.white, // لون خلفية موحد لكل ال body
  child: _pages[currentIndex],
),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF536D82), // لون الخلفية
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black26,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              backgroundColor: const Color(0xFF536D82),
              color: const Color(0xFFDDE6ED), //لون الايقونات الغير نشطه
              activeColor: const Color(0xFF9DB2BF),
              tabBackgroundColor: const Color(0xFF26374D), 
              gap: 8,
              padding: const EdgeInsets.all(12),
              onTabChange: goToPage,
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.search, text: 'Search'),
                GButton(icon: Icons.person, text: 'Profile'),
                GButton(icon: Icons.settings, text: 'Settings'),
              ],
            ),
          ),
        ),
      ),

      // Floating Action Button 
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), 
        child:
         FloatingActionButton(
        backgroundColor: const Color(0xFF9DB2BF),
        onPressed: () {
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      ),
      // تحديد مكان الفلوتنغ أكشن بوتون
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}