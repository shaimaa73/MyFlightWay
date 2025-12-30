import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'home_page.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> signUp() async {
    try {
      //  إنشاء الحساب في Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;

      if (user == null) return;

      //  تخزين بيانات اليوزر في Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // نفس uid
          .set({
            'firstName': firstNameController.text.trim(),
            'lastName': lastNameController.text.trim(),
            'email': user.email,
            'phone': phoneController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });

      // الانتقال للصفحة الرئيسية
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
  }

  Map userData = {};
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F2FF), // خلفية سماوية
      body: SingleChildScrollView(
        child: Column(
          children: [
            // صورة الهيدر الكبيرة فوق
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/signUpHeader.gif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // الحاوية البيضا
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),

              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    // عنوان الصفحة
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF26374D),
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Create your account to get started",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: firstNameController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter first name'),
                          MinLengthValidator(
                            3,
                            errorText: 'Minimum 3 charecter filled name',
                          ),
                        ]).call,
                        decoration: InputDecoration(
                          hintText: 'Enter first Name',
                          labelText: 'first name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF26374D),
                          ),
                          errorStyle: TextStyle(fontSize: 18.0),
                          filled: true,
                          fillColor: Color(0xFFF7F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: lastNameController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter last name'),
                          MinLengthValidator(
                            3,
                            errorText: 'Last name should be atleast 3 charater',
                          ),
                        ]).call,
                        decoration: InputDecoration(
                          hintText: 'Enter last Name',
                          labelText: 'Last name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF26374D),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter email address'),
                          EmailValidator(
                            errorText: 'Please correct email filled',
                          ),
                        ]).call,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF26374D),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phoneController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter mobile number'),
                          PatternValidator(
                            r'^[0-9]{10}$',
                            errorText: 'Enter valid mobile number',
                          ),
                        ]).call,
                        decoration: InputDecoration(
                          hintText: 'Mobile',
                          labelText: 'Mobile',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color(0xFF26374D),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true, // يخفي الباسورد
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter password'),
                          MinLengthValidator(
                            6,
                            errorText: 'Password must be at least 6 characters',
                          ),
                        ]).call,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF26374D),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF26374D),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // زر التسجيل
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF26374D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            signUp();
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
