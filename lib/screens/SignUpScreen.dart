import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final email = TextEditingController();

  final username = TextEditingController();

  final password = TextEditingController();

  final confimPassword = TextEditingController();

  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  @override
  // void initState() {
  //   super.initState();
  //   _initializeFirebase();
  // }
  //   void _initializeFirebase() async {
  //   try {
  //     await Firebase.initializeApp();
  //   } catch(e) {
  //     print('Error initializing Firebase IN HERE: $e');
  //   }
  // }

  @override
  navigateToLoginPage(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    void signUp() async {
      if (email.text.trim().isEmpty ||
          username.text.trim().isEmpty ||
          password.text.trim().isEmpty ||
          confimPassword.text.trim().isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Validation Error'),
              content: Text('One or more fields are missing'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (!email.text.trim().toLowerCase().endsWith("@guc.edu.eg") &&
          !email.text.trim().toLowerCase().endsWith("@student.guc.edu.eg")) {
        // Show an alert or handle the validation error as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Validation Error'),
              content: Text('Email must be a GUC email'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if ((password.text != confimPassword.text)) {
        // Show an alert or handle the validation error as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Validation Error'),
              content: Text('Passwords should match each other'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if ((password.text.length < 6)) {
        // Show an alert or handle the validation error as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Validation Error'),
              content: Text('Passwords should be at least 6 characters long'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        FirebaseAuth.instance
            .fetchSignInMethodsForEmail(email.text)
            .then((signInMethods) async {
          if (!signInMethods.isEmpty) {
            // Email is  registered
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Validation Error'),
                  content: Text('email exists'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            // Email is not registered
            try {
              print('Email: ${email.text.trim()}');
              await _auth.createUserWithEmailAndPassword(
                email: email.text.trim(),
                password: password.text.trim(),
              );

              // Send email verification
              User? user = _auth.currentUser;
              // ignore: deprecated_member_use
              await user?.updateProfile(displayName: username.text);
              await user?.sendEmailVerification();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Email Verification'),
                    content: Text(
                        'A verification email has been sent to your email address. Please check your inbox and click the verification link in the email.'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/loginRoute'),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              print('Error: $e');
              // Handle authentication errors
            }
          }
        });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 100, 10, 100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 50,
                      height: 100,
                      child: Image(image: AssetImage('assets/logo.png'))),
                  Container(
                    child: Text(
                      "  GUCircle",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: email,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Username'),
                    controller: username,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: password,
                    obscureText: true,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    controller: confimPassword,
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  // Text(
                  //   "Forgot Password",
                  //   style: TextStyle(color: Colors.blue),
                  // ),
                  ElevatedButton(
                    onPressed: signUp,
                    child: Text(
                      "Signup",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        // If the button is pressed, return green, otherwise blue
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.red[500];
                        }
                        return Colors.red[500];
                      }),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () => navigateToLoginPage(context),
                  child: Text(
                    "Have an Account? Login",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
