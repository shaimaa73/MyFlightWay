import 'package:flutter/material.dart';

class SafetyEmergencyPage extends StatefulWidget {
  const SafetyEmergencyPage({super.key});

  @override
  State<SafetyEmergencyPage> createState() => _SafetyEmergencyPageState();
}

class _SafetyEmergencyPageState extends State<SafetyEmergencyPage> {
  // Controller للتحكم بل scroll الأفقي للصور
  final ScrollController _imageScrollController = ScrollController();

  @override
  void dispose() {
    _imageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6ED),

      body: CustomScrollView(
        slivers: [
          //HEADER (GIF)
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  /// GIF الخلفية
                  Image.asset(
                    'images/safetyheader.gif',
                    fit: BoxFit.cover,
                  ),

                  // Overlay غامق
                  Container(color: Colors.black.withOpacity(0.45)),

                  // محتوى الهيدر
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 64, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.health_and_safety,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Safety & Emergency",
                          style: TextStyle(
                            fontSize: 24, // أصغر لتفادي overflow
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Essential safety information for every traveler",
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
          ),

          // CONTENT 
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Onboard Safety
                  _sectionCard(
                    title: "Onboard Safety Basics",
                    icon: Icons.airplane_ticket,
                    items: const [
                      "Fasten your seatbelt whenever seated.",
                      "Follow cabin crew instructions at all times.",
                      "Review the safety card in your seat pocket.",
                    ],
                  ),

                  const SizedBox(height: 12),

                  // IMAGE SLIDER
                  _imageSliderBox(),

                  const SizedBox(height: 20),

                  // Airport Safety
                  _sectionCard(
                    title: "Airport Safety",
                    icon: Icons.local_airport,
                    items: const [
                      "Keep your belongings with you at all times.",
                      "Follow airport security instructions carefully.",
                      "Report unattended bags to airport staff.",
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Personal Safety
                  _sectionCard(
                    title: "Personal Safety",
                    icon: Icons.person,
                    items: const [
                      "Keep important documents in a secure place.",
                      "Stay aware of your surroundings.",
                      "Avoid sharing personal travel details publicly.",
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION CARD 
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF26374D)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26374D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "• $e",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF26374D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // IMAGE SLIDER CARD 
  Widget _imageSliderBox() {
    final images = [
      {
        "image": "images/onboardSafety/seatbelt.jpeg",
        "text": "Always fasten your seatbelt",
      },
      {
        "image": "images/onboardSafety/oxygen_mask.jpg",
        "text": "Put your oxygen mask on first",
      },
      {
        "image": "images/onboardSafety/emergency_exit.jpg",
        "text": "Locate the nearest emergency exit",
      },
      {
        "image": "images/onboardSafety/life_vest.jpeg",
        "text": "Life vests are under your seat",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFBF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // أزرار التنقل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _arrowButton(Icons.chevron_left, -260),
              _arrowButton(Icons.chevron_right, 260),
            ],
          ),

          const SizedBox(height: 8),

          // النص فوق الصور
          const Text(
            "Onboard Safety Visual Guide",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF26374D),
            ),
          ),

          const SizedBox(height: 12),

          // الصور 
          SizedBox(
            height: 220, 
            child: ListView.builder(
              controller: _imageScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final item = images[index];
                return Container(
                  width: 240,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          item["image"]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item["text"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF26374D),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //ARROW BUTTON 
  Widget _arrowButton(IconData icon, double offset) {
    return IconButton(
      icon: Icon(icon, color: const Color(0xFF26374D)),
      onPressed: () {
        _imageScrollController.animateTo(
          _imageScrollController.offset + offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }
}