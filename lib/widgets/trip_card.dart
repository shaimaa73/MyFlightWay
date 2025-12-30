import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/dialogs/add_trip_dialog.dart';


class TripCard extends StatelessWidget {
  final QueryDocumentSnapshot tripData;

  const TripCard({super.key, required this.tripData});

  // فنكشن حذف الرحلة
  Future<void> deleteTrip(BuildContext context) async {
    // Dialog تأكيد الحذف
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),

    // العنوان مع زر X فوق 
    titlePadding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Delete Trip",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF26374D),
          ),
        ),

       // زر الإلغاء
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF536D82)),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    ),

    content: const Text(
      "Are you sure you want to delete this trip?",
      style: TextStyle(color: Color(0xFF536D82)),
    ),

    // زر OK 
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text(
          "OK",
          style: TextStyle(
            color: Color(0xFF26374D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
    );

    // إذا المستخدم أكد الحذف
    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(tripData.id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    //  حساب وقت الخروج من البيت 
// نجيب تاريخ الرحلة
final tripDate =
    (tripData['tripDate'] as Timestamp).toDate();
// نجيب وقت الخروج من البيت HH:MM
final leaveHome = tripData['leaveHome'] as String;
// نفصل الساعة والدقيقة
final parts = leaveHome.split(":");
final hour = int.tryParse(parts[0]);
final minute = int.tryParse(parts[1]);
// ندمجهم في DateTime واحد
DateTime? leaveHomeDateTime;
if (hour != null && minute != null) {
  leaveHomeDateTime = DateTime(
    tripDate.year,
    tripDate.month,
    tripDate.day,
    hour,
    minute,
  );
}
// هل وقت الخروج انتهى؟
final bool shouldBeOnWay =
    leaveHomeDateTime != null &&
    leaveHomeDateTime.isBefore(DateTime.now());
    return GestureDetector(
      onTap: () {
        // فتح الديالوغ لعرض و تعديل الرحلة
        showDialog(
          context: context,
          builder: (_) => AddTripDialog(existingTrip: tripData),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE6ED),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // أيقونة الطائرة
            const Icon(
              Icons.flight,
              size: 32,
              color: Color(0xFF26374D),
            ),
            const SizedBox(width: 12),

            // بيانات الرحلة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${tripData['fromCountry']} – ${tripData['toCountry']}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF26374D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Departure at ${tripData['flightTime']}",
                    style: const TextStyle(
                      color: Color(0xFF536D82),
                    ),
                  ),
                  //  الرسالة الحمراء 
    if (shouldBeOnWay) ...[
      const SizedBox(height: 4),
      const Text(
        "You should be on your way",
        style: TextStyle(
          color: Color.fromARGB(255, 174, 55, 46),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    ],
                ],
              ),
            ),

            // زر الحذف 
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFF9DB2BF),
              ),
              onPressed: () => deleteTrip(context),
            ),
          ],
        ),
      ),
    );
  }
}
