import 'package:flutter/material.dart';

class AirportGuidePage extends StatefulWidget {
  const AirportGuidePage({super.key});

  @override
  State<AirportGuidePage> createState() => _AirportGuidePageState();
}

class _AirportGuidePageState extends State<AirportGuidePage> {
  int selectedTab = 0;
  int selectedGuideCard = -1;

  final List<bool> beforeFlightChecks = [];
final List<bool> afterLandingChecks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6ED),
      body: Column(
        children: [
          // HEADER 
          Container(
            height: 260,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF536D82),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(130),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.25,
                    child: Image.asset(
                      'images/guidepic.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.flight_takeoff,
                          color: Colors.white, size: 42),
                      SizedBox(height: 12),
                      Text(
                        "Airport Guide",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Step-by-step airport experience",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          
          Container(height: 24, color: const Color(0xFFDDE6ED)),

          //TABS 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFEFBF6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF9DB2BF)),
              ),
              child: Row(
                children: [
                  _tabButton("Guide", 0),
                  _tabButton("Do & Don’ts", 1),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // CONTENT 
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: selectedTab == 0
    ? _guideMainController()
    : _doDontSection(),
            ),
          ),
        ],
      ),
    );
  }

  // TAB BUTTON
  Widget _tabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF26374D)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    isSelected ? Colors.white : const Color(0xFF26374D),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // GUIDE MAIN CONTROLLER 
Widget _guideMainController() {
  // إذا ما اختار كارد يعرض الكاردين
  if (selectedGuideCard == -1) {
    return _guideCards();
  }

  // زر رجوع و محتوى الجايد
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              setState(() => selectedGuideCard = -1);
            },
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF26374D)),
            label: const Text(
              "Back to guides",
              style: TextStyle(color: Color(0xFF26374D)),
            ),
          ),
        ),
      ),
      Expanded(
        child: selectedGuideCard == 0
            ? _beforeFlightGuide()
            : _afterLandingGuide(),
      ),
    ],
  );
}

// GUIDE CARDS 
Widget _guideCards() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _guideSelectCard(
        title: "Before Your Flight",
        subtitle: "Step-by-step guide from airport arrival to boarding",
        image: "images/guide/beforeflight.gif",
        onTap: () => setState(() => selectedGuideCard = 0),
      ),
      const SizedBox(height: 16),
      _guideSelectCard(
        title: "After Landing",
        subtitle: "What to do after landing until you exit the airport",
        image: "images/guide/afterflight.gif",
        onTap: () => setState(() => selectedGuideCard = 1),
      ),
    ],
  );
}

Widget _guideSelectCard({
  required String title,
  required String subtitle,
  required String image,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFBF6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF9DB2BF)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _beforeFlightGuide() {
  final steps = [
   {
        "text": "Arrive at the airport 1-5 hours before departure",
        "image": "images/guide/arrival.jpg"
      },
      {
        "text": "Find your airline check-in counter on the screen",
        "image": "images/guide/checkin.jpg"
      },
      {
        "text": "Show passport and ticket to the agent",
        "image": "images/guide/passport.jpg"
      },
      {
        "text": "Pass through passport control",
        "image": "images/guide/control.jpg"
      },
      {
        "text": "Place your carry-on baggage & metal items in container",
        "image": "images/guide/security.jpeg"
      },
      {
        "text": "Walk through metal detector",
        "image": "images/guide/detector.jpg"
      },
      {
        "text": "You are in the secure boarding area now, find your gate on the screen",
        "image": "images/guide/gate.jpg"
      },
      {
        "text": "Have a seat or visit shops",
        "image": "images/guide/seat.jpg"
      },
      {
        "text": "Be at the gate 45-60 minutes before takeoff",
        "image": "images/guide/boarding.jpg"
      },
      
  ];

  return _guideListBuilder(steps, beforeFlightChecks);
}

  Widget _afterLandingGuide() {
  final steps = [
    {
      "text": "Follow arrival signs after leaving the aircraft",
      "image": "images/guide/arrivalhall.jpg"
    },
    {
      "text": "Proceed to passport control",
      "image": "images/guide/passportcontrol.jpg"
    },
    {
      "text": "Collect your luggage from the baggage claim",
      "image": "images/guide/baggage.jpg"
    },
    {
      "text": "Pick up your luggage and place it on a baggage trolley to make it easier to carry through the airport",
      "image": "images/guide/trolley.jpg"
    },
    {
      "text": "Exit the terminal or follow transfer signs",
      "image": "images/guide/airportexit.jpg"
    },
  ];

  return _guideListBuilder(steps, afterLandingChecks);
}

Widget _guideListBuilder(
  List<Map<String, String>> guides,
  List<bool> checkList,
) {
  if (checkList.length != guides.length) {
    checkList.clear();
    checkList.addAll(List.generate(guides.length, (_) => false));
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: guides.length,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFEFBF6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF9DB2BF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: checkList[index],
                  activeColor: const Color(0xFF536D82),
                  onChanged: (v) {
                    setState(() => checkList[index] = v!);
                  },
                ),
                Expanded(
                  child: Text(
                    guides[index]["text"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF26374D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                guides[index]["image"]!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      );
    },
  );
}


 // DO & DON'T SECTION 
Widget _doDontSection() {
  final doItems = [
    {
      "icon": Icons.access_time,
      "text": "Arrive Early",
    },
    {
      "icon": Icons.description,
      "text": "Check & Print Boarding Pass",
    },
    {
      "icon": Icons.security,
      "text": "Prepare for Security Check",
    },
    {
      "icon": Icons.local_drink,
      "text": "Stay Hydrated",
    },
    {
      "icon": Icons.backpack,
      "text": "Carry Essentials in Hand Luggage",
    },
    {
      "icon": Icons.event_seat,
      "text": "Listen to Boarding Announcements",
    },
  ];

  final dontItems = [
    {
      "icon": Icons.alarm_off,
      "text": "Don’t Arrive Late",
    },
    {
      "icon": Icons.watch,
      "text": "Avoid Excessive Jewelry",
    },
    {
      "icon": Icons.block,
      "text": "Don’t Block Aisles",
    },
    {
      "icon": Icons.backpack_outlined,
      "text": "Don’t Overpack",
    },
    {
      "icon": Icons.no_food,
      "text": "Don’t Carry Restricted Items",
    },
    {
      "icon": Icons.volume_off,
      "text": "Don’t Ignore Crew Instructions",
    },
  ];

  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      //DO HEADER 
      _doDontHeader("Do"),

      _doDontGrid(doItems, Colors.green),

      const SizedBox(height: 28),

      // DON'T HEADER
      _doDontHeader("Don’t"),

      _doDontGrid(dontItems, Colors.redAccent),
    ],
  );
}

//HEADER
Widget _doDontHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF26374D),
      ),
    ),
  );
}

// GRID
Widget _doDontGrid(List<Map<String, dynamic>> items, Color iconColor) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEFBF6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF9DB2BF)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item["icon"],
              size: 30,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                item["text"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF26374D),
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}