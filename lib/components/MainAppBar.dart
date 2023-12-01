import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String title;
  final bool goBack;
  const MainAppBar(
      {required this.appBar, required this.title, required this.goBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: goBack
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Row(children: [
          Image.asset('assets/logo.png', height: 40, width: 40),
          const SizedBox(
            width: 10,
          ),
          Text(title, style: TextStyle(color: Colors.white))
        ]),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 83, 69, 22)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
