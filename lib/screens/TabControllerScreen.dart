import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/components/mainAppBar.dart';
import 'package:gucircle/screens/AcademicQuestionsScreen.dart';
import 'package:gucircle/screens/ConfessionsScreen.dart';
import 'package:gucircle/screens/EventsScreen.dart';
import 'package:gucircle/screens/ImportantNumbersScreen.dart';
import 'package:gucircle/screens/LostAndFoundScreen.dart';
import 'package:gucircle/screens/MainDrawer.dart';
import 'package:gucircle/screens/OfficesScreen.dart';
import 'package:gucircle/screens/QuestionsScreen.dart';
import 'package:gucircle/screens/UploadAcademicQuestionScreen.dart';
import 'package:gucircle/screens/UploadConfessionScreen.dart';
import 'package:gucircle/screens/UploadEventScreen.dart';
import 'package:gucircle/screens/UploadLostAndFoundScreen.dart';
import 'package:gucircle/screens/UploadQuestionScreen.dart';

class TabsControllerScreen extends StatefulWidget {
  @override
  _TabsControllerScreenState createState() => _TabsControllerScreenState();
}

class _TabsControllerScreenState extends State<TabsControllerScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveButtonClickToDatabase(String buttonName) async {
    print(buttonName);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await firestore
              .collection('ButtonsClicks')
              .doc(user.uid + buttonName)
              .update({
            'count': FieldValue.increment(1),
          });
        } catch (e) {
          await firestore
              .collection('ButtonsClicks')
              .doc(user.uid + buttonName)
              .set({
            'button': buttonName,
            'user': user.uid,
            'count': 1,
          });
        }
      }
    } catch (e) {
      print("Error saving button click");
    }
  }

  int selectedItem = 0;
  List<String> titles = [
    "Confessions",
    "Academic Questions",
    "Lost and Found",
    "Events"
  ];
  List<String> buttonNames = [
    "Confessions",
    "AcademicQuestions",
    "LostAndFound",
    "Events"
  ];
  static List<Widget> _widgetOptions = <Widget>[
    ConfessionsScreen(),
    QuestionsScreen(),
    LostAndFoundScreen(),
    EventsScreen(),
  ];
  goToUploadConfession(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadConfessionScreen();
    }));
  }

  gotoUploadAcademicQuestion(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadQuestionScreen();
    }));
  }

  goToUploadEvent(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadEventScreen();
    }));
  }

  goToUploadRating(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadConfessionScreen();
    }));
  }

  goToUploadLostAndFound(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadLostAndFoundScreen();
    }));
  }

  void showAddSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (sheetContext) {
          return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () {
                                saveButtonClickToDatabase('UploadConfession');
                                goToUploadConfession(context);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(50, 255, 64, 118),
                                    ),
                                    child: Image.asset(
                                      "assets/chat.png",
                                      width: 40,
                                      height: 40,
                                      color: Color.fromARGB(201, 255, 64, 118),
                                    ),
                                  ),
                                  Text("Confessions"),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                saveButtonClickToDatabase(
                                    'UploadAcademicQuestion');
                                gotoUploadAcademicQuestion(context);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(50, 255, 150, 64),
                                    ),
                                    child: Image.asset(
                                      "assets/open-book.png",
                                      width: 40,
                                      height: 40,
                                      color: Color.fromARGB(255, 255, 150, 64),
                                    ),
                                  ),
                                  const Text(
                                    'Academic',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                saveButtonClickToDatabase('UploadLostAndFound');
                                goToUploadLostAndFound(context);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(50, 64, 163, 255),
                                    ),
                                    child: Image.asset(
                                      "assets/lost-and-found1.png",
                                      width: 40,
                                      height: 40,
                                      color: Color.fromARGB(255, 64, 163, 255),
                                    ),
                                  ),
                                  Text('Lost & Found')
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                saveButtonClickToDatabase('UploadEvent');
                                goToUploadEvent(context);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(50, 89, 255, 64),
                                    ),
                                    child: Image.asset(
                                      "assets/event.png",
                                      width: 40,
                                      height: 40,
                                      color: Color.fromARGB(255, 89, 255, 64),
                                    ),
                                  ),
                                  Text('Event')
                                ],
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     saveButtonClickToDatabase('UploadRating');
                            //     goToUploadRating(context);
                            //   },
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         padding: EdgeInsets.all(20),
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(10.0),
                            //           color: Color.fromARGB(50, 255, 252, 64),
                            //         ),
                            //         child: Image.asset(
                            //           "assets/star.png",
                            //           width: 40,
                            //           height: 40,
                            //           color: Color.fromARGB(255, 255, 252, 64),
                            //         ),
                            //       ),
                            //       Text('Rating')
                            //     ],
                            //   ),
                            // )
                          ]),
                    ),
                  ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
        title: titles[selectedItem],
        goBack: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveButtonClickToDatabase('MainAddButton');
          showAddSheet(context);
        },
        child: Image.asset(
          "assets/add.png",
        ),
      ),
      endDrawer: MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              saveButtonClickToDatabase(buttonNames[index]);
              selectedItem = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                label: "0",
                icon: Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        width: 30,
                        child: selectedItem == 0
                            ? Image.asset(
                                "assets/speak2.png",
                              )
                            : Image.asset(
                                "assets/speak3.png",
                                color: Colors.grey[600],
                              ),
                      ),
                      Text(
                        "Confessions",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )),
            BottomNavigationBarItem(
              label: "1",
              icon: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      width: 30,
                      child: selectedItem == 1
                          ? Image.asset(
                              "assets/open-book.png",
                              color: Colors.blue,
                            )
                          : Image.asset(
                              'assets/open-book.png',
                              color: Colors.grey[400],
                            ),
                    ),
                    Text(
                      "Academic",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "2",
              icon: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      width: 30,
                      child: selectedItem == 2
                          ? Image.asset(
                              "assets/lost-and-found3.png",
                            )
                          : Image.asset(
                              'assets/lost-and-found1.png',
                              color: Colors.grey[400],
                            ),
                    ),
                    Text(
                      "Lost&Found",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "3",
              icon: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 30,
                    child: selectedItem == 3
                        ? Image.asset(
                            "assets/event.png",
                            color: Color.fromARGB(255, 5, 153, 10),
                          )
                        : Image.asset(
                            'assets/event.png',
                            color: Colors.grey[400],
                          ),
                  ),
                  Text(
                    "Events",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ]),
      body: _widgetOptions.elementAt(selectedItem),
    );
  }
}
