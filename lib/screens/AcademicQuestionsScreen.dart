import 'package:flutter/material.dart';
import 'package:gucircle/Question.dart';

class AcademicQuestionsScreen extends StatelessWidget {
  final all = [
    Question(
        id: "0",
        name: "pp",
        body: "ppppppppppppppp",
        replies: 18,
        user: "",
        category: "Courses"),
    Question(
        id: "0",
        name: "pp",
        body: "ppppppppppppppp",
        replies: 18,
        user: "",
        category: "Stuff"),
    Question(
        id: "0",
        name: "pp",
        body: "ppppppppppppppp",
        replies: 18,
        user: "",
        category: "Books")
  ];
  final courses = [
    Question(
        id: "0",
        name: "pp",
        body: "ppppppppppppppp",
        replies: 18,
        user: "",
        category: "Courses")
  ];
  final stuff = [
    Question(
        id: "0",
        name: "pp",
        body: "ppppppppppppppp",
        replies: 18,
        user: "",
        category: "Stuff")
  ];
  final books = [
    Question(
        id: "0",
        name: "pp",
        body: "ppppppppppppppp",
        replies: 18,
        user: "",
        category: "Books")
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Courses',
              ),
              Tab(
                text: 'Stuff',
              ),
              Tab(
                text: 'Books',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}
