import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function 
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  int currentIndex = 0; // تحديد الصفحة الحالية

  // الصفحات 
  final List<Widget> _pages = [
  const HomePage(),
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

        IconButton(
  icon: const Icon(Icons.logout, color: Colors.white),
  onPressed: () {
    signOut(); //  تسجيل الخروج
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
    //  floating Action Button using for signout , 


  }
}