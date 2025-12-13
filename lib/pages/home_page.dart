import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

// كنترولر للبحث
final TextEditingController searchController = TextEditingController();

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
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  int currentIndex = 0; // تحديد الصفحة الحالية

  // الصفحات
  final List<Widget> _pages = [
    const HomePageContent(),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('images/Logomini.png', height: 50, fit: BoxFit.contain),
            const SizedBox(width: 8),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
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
        width: double.infinity,
        height: double.infinity,
        color: Colors.white, // لون خلفية موحد لكل ال body
        child: _pages[currentIndex],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // لون الخلفية
          boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black26)],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              backgroundColor: Colors.white,
              color: const Color(0xFFDDE6ED), //لون الايقونات الغير نشطه
              // activeColor: const Color(0xFF9DB2BF),
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
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF9DB2BF),
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      // تحديد مكان الفلوتنغ أكشن بوتون
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
    //  floating Action Button using for signout ,
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      color: Colors.white,
      child: 
    SingleChildScrollView(
      child: Column(
        children: [

          //  Stack حتى اقدر احط النص والسرش فوق الصورة
          Stack(
            clipBehavior: Clip.none, // هيك بسمح للسيرش يطلع شوي برا الصورة
            children: [
              
              // صورة الهيدر
              Container(
                height: 260,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/plane_header.jpg"), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // النص الي جوا الصورة
              const Positioned(
                left: 16,
                bottom: 50, //  النص يطلع فوق مكان السيرش
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start your trip",
                      style: TextStyle(
                        fontSize: 22,
                       color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black45,
                              offset: Offset(0, 3),
                            ),
                          ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "with Us !",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black45,
                              offset: Offset(0, 3),
                            ),
                          ],
                      ),
                    ),
                  ],
                ),
              ),

              // السيرش بار نصو فوق الصورة ونصو تحت
              Positioned(
                left: 16,
                right: 16,
                bottom: -25, 
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
  controller: searchController,
  onChanged: (value) {
    setState(() {}); // عشان كل ما يكتب اليوزر حرف يعمل تحديث للواجهة
  },
  decoration: InputDecoration(
    icon: Icon(Icons.search, color: Colors.grey[600]),
    border: InputBorder.none,
    hintText: "Enter your destination",
    hintStyle: const TextStyle(color: Colors.grey),
  ),
),
                ),
              ),

              StreamBuilder(
  //  نراقب Collection "destinations"
  stream: FirebaseFirestore.instance
      .collection('destinations')

      //   نبحث عن أي اسم ببلش باللي بكتبو اليوزر في search
      .where('name', isGreaterThanOrEqualTo: searchController.text)

      //   شرط يساعد على البحث بالحروف (قبل z)
      .where('name', isLessThan: searchController.text + 'z')

      .snapshots(),

  builder: (context, snapshot) {
    //  لو البيانات ما وصلت لسا
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    //  كل الدوكيومنتس اللي رجعت من Firestore
    final results = snapshot.data!.docs;

    // عرض نتائج البحث في لست
    return ListView.builder(
      shrinkWrap: true, //  حتى ما يخربط الواجهة داخل Column أو Stack
      itemCount: results.length,

      itemBuilder: (context, index) {
        // تحويل الدوكومنت إلى Map عشان نقدر نقرأه
        final data = results[index].data() as Map<String, dynamic>;

        //  شكل العنصر الي يظهر بلبحث
        return ListTile(
          title: Text(data['name']),          // اسم المدينة
          subtitle: Text(data['description']), // وصف المدينة
        );
      },
    );
  },
)
            ],
          ),

          // مسافة حتى السيرش ما يدخل بالمحتوى الي تحت
          const SizedBox(height: 50),

          const SizedBox(height: 20),
        ],
      ),
    ),
    );
  }
}
