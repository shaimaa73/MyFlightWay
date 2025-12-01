import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'package:flutter_application_1/pages/register.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

Future<void> signIn() async { 
try { 
final userCredential = await FirebaseAuth.instance 
.signInWithEmailAndPassword( 
email: emailController.text.trim(), 
password: passwordController.text.trim()); 
} catch (e) { 
} 
} 

  final _formKey = GlobalKey<FormState>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form( 
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo 
                Image.asset(
                  'images/myLogo.png',
                  width: 400,   // حجم الصورة 
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 1),

                //  Email Field 
                TextFormField(  
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Color(0xFF9DB2BF)),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Color(0xFF536D82)),
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFF9DB2BF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) { //  الفحص
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]+')
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(  
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFF9DB2BF)),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Color(0xFF536D82)),
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFF9DB2BF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) { // فحص الباسورد
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                //  Login Button 
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                   onPressed: () {

                    // فحص الحقول
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    // عرض رسالة النجاح 
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Login successful!"),
                        backgroundColor: Color(0xFF536D82),
                        duration: Duration(seconds: 1), // مدة عرض الرسالة
                      ),
                    );

                    // الانتظار قبل التنقل عشان المستخدم يشوف الرسالة
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    });
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9DB2BF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF26374D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //  Sign Up Text 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account? ",
                      style: TextStyle(color: Color(0xFF536D82)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Color(0xFF9DB2BF)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}