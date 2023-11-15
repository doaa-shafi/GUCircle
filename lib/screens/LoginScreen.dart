import 'package:flutter/material.dart';
import './SignUpScreen.dart';

class LoginScreen extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  navigateToSingupPage(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return SignUpScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 100, 10, 100),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 100,
                    height: 100,
                    child: Image(image: AssetImage('assets/logo.jpeg'))),
                Container(
                  child: Text(
                    "GUCircle",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    controller: password),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: null,
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
    );
  }
}
