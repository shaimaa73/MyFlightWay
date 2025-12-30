import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'essentials_card.dart';
import 'essentials_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../category_detail_page.dart';

class TravelEssentialsPage extends StatefulWidget {
  const TravelEssentialsPage({super.key});

  @override
  State<TravelEssentialsPage> createState() => _TravelEssentialsPageState();
}

class _TravelEssentialsPageState extends State<TravelEssentialsPage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference cardsRef = FirebaseFirestore.instance.collection(
    'users',
  );

  //  category items
  final Map<String, List<String>> airportCategories = {
  "food": [
    "Solid food (sandwiches, snacks)",
    "Baby food & formula",
    "Powdered drinks & coffee",
    "Empty water bottle",
    "Packaged sweets & chocolate",
    "Dry fruits & nuts",
    "Special dietary food",
    "Duty-free liquids (sealed)",
  ],

  "medical": [
    "Prescription medications",
    "Medical documents",
    "Insulin & injections",
    "Liquid medicine (with prescription)",
    "Medical devices (inhaler, CPAP)",
    "Basic first aid kit",
    "Pain relievers",
    "Thermometers",
  ],

  "tools": [
    "Small household tools (checked luggage)",
    "Screwdrivers (checked luggage)",
    "Power tools (checked luggage)",
    "Measuring tape",
    "Cables & adapters",
    "Batteries (limited quantity)",
    "Electronic accessories",
    "Flashlights (no loose batteries)",
  ],

  "sport": [
    "Sports clothing",
    "Camping tents (checked luggage)",
    "Sleeping bags",
    "Hiking gear",
    "Tennis rackets",
    "Fishing equipment",
    "Yoga mats",
    "Protective gear",
  ],

  "sharp": [
    "Knives (checked luggage only)",
    "Scissors (checked luggage)",
    "Razors (checked luggage)",
    "Multi-tools (checked luggage)",
    "Nail clippers",
    "Needles & sewing kits",
    "Sharp kitchen tools",
    "Craft blades",
  ],
};

  void initState() {
    super.initState();
    _createDefaultCardsIfNeeded();
  }

  Future<void> _createDefaultCardsIfNeeded() async {
    final col = cardsRef.doc(uid).collection('travel_essentials');
    final snap = await col.get();

    if (snap.docs.isNotEmpty) return;

    await col.add({
      "title": "Checked Luggage",
      "icon": Icons.luggage.codePoint,
      "items": [
        {"text": "Clothing", "done": false},
        {"text": "Shoes", "done": false},
        {"text": "Toiletries", "done": false},
        {"text": "Extra Bag", "done": false},
      ],
    });

    await col.add({
      "title": "Carry-on Bag",
      "icon": Icons.backpack.codePoint,
      "items": [
        {"text": "Passport", "done": false},
        {"text": "Wallet", "done": false},
        {"text": "Phone", "done": false},
        {"text": "Charger", "done": false},
      ],
    });
  }

  // إضافة Card جديدة
  void _addNewCard() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "New List",
          style: TextStyle(color: Color(0xFF26374D)),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "List name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF536D82),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26374D),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (controller.text.isEmpty) return;

              await cardsRef.doc(uid).collection('travel_essentials').add({
                "title": controller.text,
                "icon": Icons.checklist.codePoint,
                "items": [],
              });

              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  //حذف Card
  Future<void> _deleteCard(String cardId) async {
    await cardsRef
        .doc(uid)
        .collection('travel_essentials')
        .doc(cardId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6ED),

      appBar: AppBar(
        title: const Text(
          "Travel Essentials",
          style: TextStyle(color: Color(0xFF26374D)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF26374D)),
      ),

      //Scroll واحد  لكل الصفحة
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //زر إضافة list
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26374D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _addNewCard,
                child: const Text(
                  "Add a new list",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Cards Grid
            StreamBuilder<QuerySnapshot>(
              stream: cardsRef
                  .doc(uid)
                  .collection('travel_essentials')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return EssentialsCard(
                      data: {
                        "id": doc.id,
                        "title": data["title"],
                        "icon": IconData(
                          data["icon"],
                          fontFamily: 'MaterialIcons',
                        ),
                        "items": data["items"],
                        "onDelete": () => _deleteCard(doc.id),
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EssentialsDetailPage(
                              title: data["title"],
                              cardId: doc.id,
                              initialItems:
                                  List<Map<String, dynamic>>.from(
                                      data["items"]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

           
          //  Baggage Weight Limits 
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image Placeholder
      Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF0F6),
          borderRadius: BorderRadius.circular(14),
        ),
       child: Image.asset(
  "images/luggage.jpeg",
  fit: BoxFit.contain,
),
       
      ),

      const SizedBox(width: 14),

      // Text Content
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Baggage Weight Limits",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26374D),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "• Carry-on: 7-10 kg\n"
              "• Checked luggage: 20-23 kg\n\n"
              "Limits depend on airline and ticket type.",
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF536D82),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 28),

            // Categories 
           //What can I bring? (BOX) 

           
Container(
  width: double.infinity,
  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(22),
      topRight: Radius.circular(22),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, -2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "What can I bring?",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF26374D),
        ),
      ),

      const SizedBox(height: 16),

      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        children: [
         _categoryCardBlue(
  context,
  title: "Food & Drinks",
  icon: Icons.fastfood,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailPage(
          title: "Food & Drinks",
          items: airportCategories["food"]!,
        ),
      ),
    );
  },
),

_categoryCardBlue(
  context,
  title: "Medical",
  icon: Icons.medical_services,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailPage(
          title: "Medical",
          items: airportCategories["medical"]!,
        ),
      ),
    );
  },
),

_categoryCardBlue(
  context,
  title: "Household & Tools",
  icon: Icons.home_repair_service,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailPage(
          title: "Household & Tools",
          items: airportCategories["tools"]!,
        ),
      ),
    );
  },
),

_categoryCardBlue(
  context,
  title: "Sport & Camping",
  icon: Icons.sports_soccer,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailPage(
          title: "Sport & Camping",
          items: airportCategories["sport"]!,
        ),
      ),
    );
  },
),

_categoryCardBlue(
  context,
  title: "Sharp Objects",
  icon: Icons.content_cut,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailPage(
          title: "Sharp Objects",
          items: airportCategories["sharp"]!,
        ),
      ),
    );
  },
),
        ],
      ),
    ],
  ),
),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  //Category Card Widget
 Widget _categoryCardBlue(
  BuildContext context, {
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFC4BCB0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}