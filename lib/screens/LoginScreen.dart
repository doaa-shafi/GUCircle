import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucircle/classes/UserModel.dart';
import './SignUpScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  navigateToSingupPage(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return SignUpScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      if (email.text == "admin" && password.text == "admin") {
        Navigator.of(context).pushReplacementNamed('/adminHome');
        return;
      }
      try {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logging in...'),
              content: Text('Please wait...'),
              actions: [],
            );
          },
        );
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            print('User signed in: ${user.uid}');
            DocumentSnapshot doc = await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();
            Map<String, dynamic> userDetails =
                doc.data() as Map<String, dynamic>;
            Provider.of<UserModel>(context, listen: false).setUser(userDetails);
            // if (email.text == "alaa_abdulla2001@hotmail.com") {
            //   Navigator.of(context).pushReplacementNamed('/adminHome');
            // } else {
            Navigator.of(context).pushReplacementNamed('/mainPage');
            // }
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Please verify your email first'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      } catch (e) {
        String errorMessage;
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-email':
              errorMessage = 'The email address is not valid.';
              break;
            case 'user-disabled':
              errorMessage =
                  'The user corresponding to the given email has been disabled.';
              break;
            case 'user-not-found':
              errorMessage =
                  'There is no user corresponding to the given email.';
              break;
            case 'wrong-password':
              errorMessage = 'The password is invalid for the given email.';
              break;
            default:
              errorMessage = 'email or pasword is incorrect.';
          }
        } else {
          errorMessage = 'An error occurred.';
        }
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
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
                      // decrease size of image
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
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: password,
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
                    onPressed: login,
                    child: Text(
                      "Login",
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
                  onTap: () => navigateToSingupPage(context),
                  child: Text(
                    "New User? Create Account",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
