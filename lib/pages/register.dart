import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> signUp() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    } catch (e) {}
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
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),

           

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
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
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xFF26374D)),
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
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xFF26374D)),
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
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Enter email address'),
                        EmailValidator(errorText: 'Please correct email filled'),
                      ]).call,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email, color: Color(0xFF26374D)),
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
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Enter mobile number'),
                        PatternValidator(
                          r'(^[0,9]{10}$)',
                          errorText: 'enter vaid mobile number',
                        ),
                      ]).call,
                      decoration: InputDecoration(
                        hintText: 'Mobile',
                        labelText: 'Mobile',
                        prefixIcon:
                            Icon(Icons.phone, color: Color(0xFF26374D)),
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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('register')),
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Form(
  //           key: _formkey,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 20.0),
  //                 child: Center(
  //                   child: SizedBox(
  //                     width: 200,
  //                     height: 150,
  //                     //decoration: BoxDecoration(
  //                     //borderRadius: BorderRadius.circular(40),
  //                     //border: Border.all(color: Colors.blueGrey)),
  //                     child: Image.asset('images/myLogo.png'),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(12.0),
  //                 child: TextFormField(
  //                   // validator: ((value) {
  //                   //   if (value == null || value.isEmpty) {
  //                   //     return 'please enter some text';
  //                   //   } else if (value.length < 5) {
  //                   //     return 'Enter atleast 5 Charecter';
  //                   //   }

  //                   //   return null;
  //                   // }),
  //                   validator: MultiValidator([
  //                     RequiredValidator(errorText: 'Enter first name'),
  //                     MinLengthValidator(
  //                       3,
  //                       errorText: 'Minimum 3 charecter filled name',
  //                     ),
  //                   ]).call,

  //                   decoration: InputDecoration(
  //                     hintText: 'Enter first Name',
  //                     labelText: 'first name',
  //                     prefixIcon: Icon(Icons.person, color: Color(0xFF26374D)),
  //                     errorStyle: TextStyle(fontSize: 18.0),
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.red),
  //                       borderRadius: BorderRadius.all(Radius.circular(9.0)),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TextFormField(
  //                   validator: MultiValidator([
  //                     RequiredValidator(errorText: 'Enter last named'),
  //                     MinLengthValidator(
  //                       3,
  //                       errorText: 'Last name should be atleast 3 charater',
  //                     ),
  //                   ]).call,
  //                   decoration: InputDecoration(
  //                     hintText: 'Enter last Name',
  //                     labelText: 'Last name',
  //                     prefixIcon: Icon(Icons.person, color: Color(0xFF26374D)),
  //                     errorStyle: TextStyle(fontSize: 18.0),
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.red),
  //                       borderRadius: BorderRadius.all(Radius.circular(9.0)),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TextFormField(
  //                   validator: MultiValidator([
  //                     RequiredValidator(errorText: 'Enter email address'),
  //                     EmailValidator(errorText: 'Please correct email filled'),
  //                   ]).call,
  //                   decoration: InputDecoration(
  //                     hintText: 'Email',
  //                     labelText: 'Email',
  //                     prefixIcon: Icon(Icons.email, color: Color(0xFF26374D)),
  //                     errorStyle: TextStyle(fontSize: 18.0),
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.red),
  //                       borderRadius: BorderRadius.all(Radius.circular(9.0)),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TextFormField(
  //                   validator: MultiValidator([
  //                     RequiredValidator(errorText: 'Enter mobile number'),
  //                     PatternValidator(
  //                       r'(^[0,9]{10}$)',
  //                       errorText: 'enter vaid mobile number',
  //                     ),
  //                   ]).call,
  //                   decoration: InputDecoration(
  //                     hintText: 'Mobile',
  //                     labelText: 'Mobile',
  //                     prefixIcon: Icon(Icons.phone, color: Color(0xFF26374D)),
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.red),
  //                       borderRadius: BorderRadius.all(Radius.circular(9)),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Center(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(18.0),
  //                   child: SizedBox(
  //                     // margin: EdgeInsets.fromLTRB(200, 20, 50, 0),
  //                     width: MediaQuery.of(context).size.width,

  //                     height: 50,
  //                     // margin: EdgeInsets.fromLTRB(200, 20, 50, 0),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Color(0xFF9DB2BF),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(30),
  //                         ),
  //                         minimumSize: Size(double.infinity, 50),
  //                       ),
  //                       onPressed: () {
  //                         if (_formkey.currentState!.validate()) {
  //                           print('form submitted');
  //                           signUp();
  //                         }
  //                       },
  //                       child: Text(
  //                         'Register',
  //                         style: TextStyle(color: Colors.white, fontSize: 22),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
                // Center(
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 20),
                //     child: Center(
                //       child: Text(
                //         'Or Sign Up Using',
                //         style: TextStyle(fontSize: 18, color: Colors.black),
                //       ),
                //     ),
                //   ),
                // ),
                // Center(
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 20, left: 90),
                //     child: Row(
                //       children: [
                //         SizedBox(
                //           height: 40,
                //           width: 40,
                //           child: Image.asset(
                //             'assets/google.png',
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         SizedBox(
                //           height: 70,
                //           width: 70,
                //           child: Image.asset(
                //             'assets/vishal.png',
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         SizedBox(
                //           height: 40,
                //           width: 40,
                //           child: Image.asset(
                //             'assets/google.png',
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Center(
                //   child: Container(
                //     padding: EdgeInsets.only(top: 60),
                //     child: Text(
                //       'SIGN IN',
                //       style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
}
