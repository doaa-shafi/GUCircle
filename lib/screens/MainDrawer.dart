import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/classes/UserModel.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(64, 63, 63, 1),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Container(
            //   height: 100,
            //   width: double.infinity,
            //   padding: EdgeInsets.all(20),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'GUCircle',
            //     style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 30,
            //         color: Colors.white),
            //   ),
            // ),
            // const SizedBox(
            //   height: 160,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.asset(
                    'assets/default-user.png',
                    height: 100,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "username",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              tileColor: const Color.fromRGBO(72, 71, 71, 1),
              leading: const FaIcon(
                FontAwesomeIcons.bell,
                color: Color.fromRGBO(181, 178, 178, 1),
              ),
              title: const Text("Notifications",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/notificationsRoute');
              },
            ),
            ListTile(
              tileColor: const Color.fromRGBO(72, 71, 71, 1),
              leading: const Icon(
                Icons.person,
                color: Color.fromRGBO(181, 178, 178, 1),
                size: 30,
              ),
              title: const Text("Edit Profile",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
            ),
            ListTile(
              tileColor: const Color.fromRGBO(72, 71, 71, 1),
              leading: const Icon(
                Icons.star,
                color: Color.fromRGBO(181, 178, 178, 1),
                size: 30,
              ),
              title: const Text("Ratings",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/ratingsRoute');
              },
            ),
            ListTile(
              tileColor: const Color.fromRGBO(72, 71, 71, 1),
              leading: Image.asset(
                'assets/phone1.png',
                color: Color.fromRGBO(181, 178, 178, 1),
                height: 28,
              ),
              title: const Text("Important Numbers",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/importantNumbersRoute');
              },
            ),
            ListTile(
              tileColor: const Color.fromRGBO(72, 71, 71, 1),
              leading: Image.asset(
                'assets/maps-and-flags.png',
                color: Color.fromRGBO(181, 178, 178, 1),
                height: 25,
              ),
              title: const Text("Maps",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/officesRoute');
              },
            ),
            ListTile(
              tileColor: Color.fromRGBO(72, 71, 71, 1),
              leading: const Icon(
                Icons.settings,
                color: Color.fromRGBO(181, 178, 178, 1),
                size: 30,
              ),
              title: const Text("Settings",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/settingsRoute');
              },
            ),
            ListTile(
              tileColor: const Color.fromRGBO(72, 71, 71, 1),
              leading: const Icon(
                Icons.logout,
                color: Color.fromRGBO(181, 178, 178, 1),
                size: 30,
              ),
              title: const Text("Log out",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logging out...'),
                      content: Text('Please wait...'),
                      actions: [],
                    );
                  },
                );
                await FirebaseAuth.instance.signOut();
                Provider.of<UserModel>(context, listen: false).clearUser();
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/loginRoute');
              },
            ),
          ],
        ),
      ),
    );
  }
}
