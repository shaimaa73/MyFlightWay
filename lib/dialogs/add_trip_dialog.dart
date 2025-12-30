import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';


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
  DateTime? selectedDate; // لتاريخ الرحله
  bool isEditing = false;
  DateTime? _leaveHomeDateTime; 
// متغير للreminder
// بنحول
// tripDate (التاريخ)
// leaveHome (الوقت HH:MM)
// إلى DateTime واحد الي اسمو  _leaveHomeDateTime;

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

        isEditing = false; // نفتحها كعرض فقط
_calculateLeaveHomeTime();
  }
  else{
    isEditing = true; // اضافة رحله جديده
  }
}

// حساب الوفت من الان لوقت الخروج من المنزل  عشان العداد

void _calculateLeaveHomeTime() {
  if (selectedDate == null || leaveHomeController.text.isEmpty) return;

  final timeParts = leaveHomeController.text.split(":");
  if (timeParts.length != 2) return;

  final hour = int.tryParse(timeParts[0]);
  final minute = int.tryParse(timeParts[1]);

  if (hour == null || minute == null) return;
// دمج تاريخ الرحله مع وقت الخروج
  _leaveHomeDateTime = DateTime(
    selectedDate!.year,
    selectedDate!.month,
    selectedDate!.day,
    hour,
    minute,
  );


}
  // دالة حفظ الرحلة في Firestore
Future<void> saveTrip() async {
  // نجيب المستخدم الحالي
  final user = FirebaseAuth.instance.currentUser;

  // تأكد إنو المستخدم مسجّل دخول
  if (user == null) {
    debugPrint("User is not logged in");
    return;
  }

  // تحقق من الحقول الأساسية
  if (fromController.text.isEmpty ||
      toController.text.isEmpty ||
      selectedDate == null) {
    debugPrint("Missing required fields");
    return;
  }

  // البيانات المشتركة بين الإضافة والتعديل
  final tripData = {
    'fromCountry': fromController.text,
    'toCountry': toController.text,
    'tripDate': Timestamp.fromDate(selectedDate!),
    'flightTime': flightTimeController.text,
    'leaveHome': leaveHomeController.text,
    'userId': user.uid,
  };

  if (widget.existingTrip == null) {
    //  حالة إضافة رحلة جديدة
    await FirebaseFirestore.instance
        .collection('trips')
        .add({
          ...tripData,
          'createdAt': Timestamp.now(), // وقت الإنشاء
        });
  } else {
    //  حالة تعديل رحلة موجودة
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.existingTrip!.id) // نفس الرحلة
        .update(tripData);
  }

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
     title: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "Add Trip",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),

    if (widget.existingTrip != null && !isEditing)
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          setState(() {
            isEditing = true;
          });
        },
      ),
  ],
),

      content: SingleChildScrollView(
        child: Column(
          children: [
            // حقل البلد الحالي
            TextField(
              controller: fromController,
              readOnly: !isEditing, // نخلي الحقول تفتح او تكون مقفوله حسب الحاله
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
              readOnly: !isEditing,
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
  if (!isEditing) return;
                  
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
        ), dialogTheme: DialogThemeData(backgroundColor: Colors.white), // خلفية الكالندر
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
                }
              
              ),
            ),
            const SizedBox(height: 12),

            // حقل وقت إقلاع الرحلة
           TextField(
  controller: flightTimeController,
  readOnly: true,
  decoration: const InputDecoration(
    labelText: "Flight Time",
    prefixIcon: Icon(Icons.flight_takeoff),
    border: OutlineInputBorder(),
  ),
  onTap: !isEditing
      ? null
      : () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    // خلفية مربع الوقت
                    backgroundColor: Colors.white,

                    // لون الساعة والدقائق 
                    hourMinuteTextColor: Color(0xFF26374D),
                    hourMinuteColor: Color(0xFFDDE6ED),

                    // لون AM/PM
                    dayPeriodTextColor: Color(0xFF26374D),
                    dayPeriodColor: Color(0xFFDDE6ED),

                    // لون العقارب (dial)
                    dialHandColor: Color(0xFF536D82),
                    dialBackgroundColor: Color(0xFFDDE6ED),

                    // لون الأرقام داخل الساعة
                    dialTextColor: Color(0xFF26374D),

                    // أزرار OK / CANCEL
                    entryModeIconColor: Color(0xFF536D82),
                  ),

                  // لون أزرار OK و Cancel
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF536D82),
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (time != null) {
            final formatted =
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

            setState(() {
              flightTimeController.text = formatted;
              
            });
          }
        },
),
            const SizedBox(height: 12),

            // حقل وقت الخروج من البيت
            TextField(
  controller: leaveHomeController,
  readOnly: true,
  decoration: const InputDecoration(
    labelText: "Leave Home Time",
    prefixIcon: Icon(Icons.alarm),
    border: OutlineInputBorder(),
  ),
  onTap: !isEditing
      ? null
      : () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  timePickerTheme: const TimePickerThemeData(
                    // خلفية مربع الوقت
                    backgroundColor: Colors.white,

                    // لون الساعة والدقائق 
                    hourMinuteTextColor: Color(0xFF26374D),
                    hourMinuteColor: Color(0xFFDDE6ED),

                    // لون AM/PM
                    dayPeriodTextColor: Color(0xFF26374D),
                    dayPeriodColor: Color(0xFFDDE6ED),

                    // لون العقارب (dial)
                    dialHandColor: Color(0xFF536D82),
                    dialBackgroundColor: Color(0xFFDDE6ED),

                    // لون الأرقام داخل الساعة
                    dialTextColor: Color(0xFF26374D),

                    // أزرار OK / CANCEL
                    entryModeIconColor: Color(0xFF536D82),
                  ),

                  // لون أزرار OK و Cancel
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF536D82),
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (time != null) {
            final formatted =
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

            setState(() {
              leaveHomeController.text = formatted;
              _calculateLeaveHomeTime();
            });
          }
        },
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
    children: [
      const Divider(),
      const SizedBox(height: 8),

      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: Color(0xFF26374D)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              "Reminder is active for this trip",
              style: TextStyle(
                color: Color(0xFF26374D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      // مكان ال timer
    SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Transform.scale(
    scale: 0.85, 
    alignment: Alignment.center,
    child: TimerCountdown(
      endTime: _leaveHomeDateTime!,
      format: CountDownTimerFormat.daysHoursMinutesSeconds,
      timeTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF536D82),
      ),
      colonsTextStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF536D82),
      ),
    ),
  ),
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
          onPressed: isEditing ?
          saveTrip : null,
//           إذا isEditing == true
// ف onPressed = saveTrip
// إذا isEditing == false
// ف onPressed = null (الزر يتعطل)
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