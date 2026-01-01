import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'all_trips_page.dart';

class TripsNotificationPage extends StatelessWidget {
  const TripsNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF26374D)),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Color(0xFF26374D)),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        // نجيب اسم اليوزر + عدد الرحلات
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Center(child: Text("User data not found"));
            }

            final userData =
                userSnapshot.data!.data() as Map<String, dynamic>;
            final firstName = userData['firstName'] ?? "Traveler";

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('trips')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, tripsSnapshot) {
                if (tripsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (tripsSnapshot.hasError) {
                  return const Center(
                    child: Text("Failed to load notifications"),
                  );
                }

                final tripsCount = tripsSnapshot.data!.docs.length;
                final tripText = tripsCount == 1 ? 'trip' : 'trips'; //if trips=1 then type trip instead of trips in the displayed message

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE6ED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hello username
                      Text(
                        "Hello, $firstName 👋",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF26374D),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // النص الرئيسي
                     Text(
  "You currently have $tripsCount $tripText.",
  style: const TextStyle(
    fontSize: 15,
    color: Color(0xFF536D82),
  ),
),

                      const SizedBox(height: 8),

                      // Tap here
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllTripsPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Tap here to view them",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF26374D),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}