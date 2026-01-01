import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  final doc = await usersRef.doc(user!.uid).get();

  if (!doc.exists) {
    // لو اليوزر ما عنده document
    setState(() => isLoading = false);
    return;
  }

  final data = doc.data()!;

  firstNameController.text = data['firstName'] ?? '';
  lastNameController.text  = data['lastName'] ?? '';
  phoneController.text     = data['phone'] ?? '';

  setState(() => isLoading = false);
}

  Future<void> _saveChanges() async {
    await usersRef.doc(user!.uid).set({
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'phone': phoneController.text.trim(),
    }, SetOptions(merge: true));
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveChanges();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage("images/profilepic.jpg"), 
            ),
            const SizedBox(height: 25),

            _profileCard(
              label: "First Name",
              controller: firstNameController,
              enabled: isEditing,
              icon: Icons.person,
            ),

            _profileCard(
              label: "Last Name",
              controller: lastNameController,
              enabled: isEditing,
              icon: Icons.person_outline,
            ),

            _profileCard(
              label: "Email",
              initialValue: user!.email!,
              enabled: false,
              icon: Icons.email,
            ),

            _profileCard(
              label: "Phone",
              controller: phoneController,
              enabled: isEditing,
              icon: Icons.phone,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26374D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.logout,
                color: Colors.white,
                ),
                label: const Text(
                  "Log Out",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    required bool enabled,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE6ED),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        enabled: enabled,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          border: InputBorder.none,
          icon: Icon(icon, color: const Color(0xFF26374D)),
        ),
      ),
    );
  }
}