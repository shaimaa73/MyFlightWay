import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTripDialog extends StatefulWidget {
  final QueryDocumentSnapshot? existingTrip;

  const AddTripDialog({super.key, this.existingTrip});

  @override
  State<AddTripDialog> createState() => _AddTripDialogState();
}

class _AddTripDialogState extends State<AddTripDialog> {
  // Controllers لحقول الإدخال
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final flightTimeController = TextEditingController();
  final leaveHomeController = TextEditingController();

  // متغير لحفظ تاريخ الرحلة
  DateTime? selectedDate;

@override
void initState() {
  super.initState();
// اذا فتحنا ديالوغ لرحله موجوده
  if (widget.existingTrip != null) {
    fromController.text = widget.existingTrip!['fromCountry'];
    toController.text = widget.existingTrip!['toCountry'];
    flightTimeController.text = widget.existingTrip!['flightTime'];
    leaveHomeController.text = widget.existingTrip!['leaveHome'];
    selectedDate =
        (widget.existingTrip!['tripDate'] as Timestamp).toDate();
  }
}
  // دالة حفظ الرحلة في Firestore
 Future<void> saveTrip() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("User is not logged in");
    return;
  }

  if (fromController.text.isEmpty ||
      toController.text.isEmpty ||
      selectedDate == null) {
    debugPrint("Missing required fields");
    return;
  }

// فصل الساعة والدقيقة من النص (HH:MM)
  final parts = leaveHomeController.text.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  //  نركب DateTime لل reminder
  final reminderDateTime = DateTime(
    selectedDate!.year,
    selectedDate!.month,
    selectedDate!.day,
    hour,
    minute,
  );

  //  حفظ كل اشي في Firestore
  await FirebaseFirestore.instance.collection('trips').add({
    'fromCountry': fromController.text,
    'toCountry': toController.text,
    'tripDate': Timestamp.fromDate(selectedDate!),
    'flightTime': flightTimeController.text,
    'leaveHome': leaveHomeController.text,
    'userId': user.uid,
    'createdAt': Timestamp.now(),
  });

    // إغلاق ال dialog بعد الحفظ
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // خلفية بيضا لل dialog
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      // عنوان ال dialog
      title: const Text(
        "Add Trip",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            // حقل البلد الحالي
            TextField(
              controller: fromController,
              decoration: const InputDecoration(
                labelText: "From",
                prefixIcon: Icon(Icons.flight_takeoff),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // حقل وجهة السفر
            TextField(
              controller: toController,
              decoration: const InputDecoration(
                labelText: "To",
                prefixIcon: Icon(Icons.flight_land),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // زر اختيار تاريخ الرحلة
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFF536D82),

    side: BorderSide(
                    color: const Color(0xFF536D82),
    ),
  ),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  selectedDate == null
                      ? "Select Trip Date"
                      : selectedDate!.toString().split(' ')[0],
                ),
                onPressed: () async {
                  
                  final date = await showDatePicker(
  context: context,
  firstDate: DateTime.now(),
  lastDate: DateTime(2030),
  builder: (context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Theme.of(context).colorScheme.primary, // لون الهيدر و اليوم المحدد
          onSurface: Colors.black, // لون الأيام
        ),
        dialogBackgroundColor: Colors.white, // خلفية الكالندر
      ),
      child: child!,
    );
  },
);
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // حقل وقت إقلاع الرحلة
            TextField(
              controller: flightTimeController,
              decoration: const InputDecoration(
                labelText: "Flight Time (HH:MM)",
                prefixIcon: Icon(Icons.schedule),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // حقل وقت الخروج من البيت
            TextField(
              controller: leaveHomeController,
              decoration: const InputDecoration(
                labelText: "Leave Home Time",
                prefixIcon: Icon(Icons.alarm),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // جملة التنبيه تحت الحقول
            if (widget.existingTrip == null)
  const Text(
    "A reminder will be added to notify you when it's time to leave home.",
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 13, color: Colors.grey),
  )
else
  Column(
    children: const [
      Divider(),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: Color(0xFF26374D)),
          SizedBox(width: 6),
          Text(
            "Reminder is active for this trip",
            style: TextStyle(
              color: Color(0xFF26374D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  ),
          ],
        ),
      ),

      // أزرار التحكم
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor:  const Color(0xFF536D82),
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton.icon(
          onPressed: saveTrip,
          style: 
           ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF536D82),
foregroundColor: Colors.white,
           ),
          icon: const Icon(Icons.save),
          label: const Text("Save"),
        ),
      ],
    );
  }
}