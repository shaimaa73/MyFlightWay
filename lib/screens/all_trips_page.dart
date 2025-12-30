import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/trip_card.dart';

class AllTripsPage extends StatelessWidget {
  const AllTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar 
      appBar: AppBar(
  backgroundColor: Colors.white,
  leading: const BackButton(color: Colors.black),
  title: const Text(
    "All Trips",
    style: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('trips')
              .where('userId', isEqualTo: userId)
              .orderBy('tripDate')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Failed to load trips",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final trips = snapshot.data!.docs;

            if (trips.isEmpty) {
              return const Center(
                child: Text(
                  "No trips found",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF536D82),
                  ),
                ),
              );
            }

            // ListView لعرض كل الرحلات
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return TripCard(tripData: trips[index]);
              },
            );
          },
        ),
      ),
    );
  }
}