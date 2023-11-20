import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gucircle/screens/ConfessionsScreen.dart';
import 'package:gucircle/screens/ImportantNumbersScreen.dart';
import 'package:gucircle/screens/LostAndFoundScreen.dart';
import 'package:gucircle/screens/MainDrawer.dart';
import 'package:gucircle/screens/OfficesScreen.dart';
import 'package:gucircle/screens/UploadAcademicQuestionScreen.dart';
import 'package:gucircle/screens/UploadConfessionScreen.dart';
import 'package:gucircle/screens/UploadEventScreen.dart';
import 'package:gucircle/screens/UploadLostAndFoundScreen.dart';

class TabsControllerScreen extends StatefulWidget {
  @override
  _TabsControllerScreenState createState() => _TabsControllerScreenState();
}

class _TabsControllerScreenState extends State<TabsControllerScreen> {
  int selectedItem = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ConfessionsScreen(),
    ImportantNumbersScreen(),
    LostAndFoundScreen(),
    OfficesScreen(),
  ];
  goToUploadConfession(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadConfessionScreen();
    }));
  }
  gotoUploadAcademicQuestion(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadAcademicQuestionScreen();
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
              child: Text("Post",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
            ),
            SizedBox(
              height: 300,
              child: GridView.count(
                  crossAxisCount: 3, crossAxisSpacing: 10, 
                  children: [
                    GestureDetector(
                      onTap: ()=>{goToUploadConfession(context)},
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Color.fromARGB(50, 255, 64, 118),),
                            child: Image.asset(
                                "assets/chat.png",
                              width: 40,
                              height: 40,
                              color: Color.fromARGB(201, 255, 64, 118),),
                              ),
                              Text("Confessions"),
                        ],
                      ),
                    ),
                        GestureDetector(
                          onTap: () => gotoUploadAcademicQuestion(context),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Color.fromARGB(50, 255, 150, 64),),
                                              child: Image.asset(
                                "assets/open-book.png",
                               width: 40,
                              height: 40,
                              color: Color.fromARGB(255, 255, 150, 64),),),
                              Text('Academic Questions')
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => goToUploadLostAndFound(context),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Color.fromARGB(50, 64, 163, 255),),
                                              child: Image.asset(
                                "assets/lost-and-found1.png",
                               width: 40,
                              height: 40,
                              color: Color.fromARGB(255, 64, 163, 255),),),
                              Text('Lost & Found')
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => goToUploadEvent(context),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Color.fromARGB(50, 89, 255, 64),),
                                              child: Image.asset(
                                "assets/event.png",
                               width: 40,
                              height: 40,
                              color: Color.fromARGB(255, 89, 255, 64),),), 
                              Text('Event')
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => goToUploadRating(context),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Color.fromARGB(50, 255, 252, 64),),
                                              child: Image.asset(
                                "assets/star.png",
                               width: 40,
                              height: 40,
                              color: Color.fromARGB(255, 255, 252, 64),),),
                              Text('Rating')
                            ],
                          ),
                        )
                    ]),
            ),
          ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(children: [
            Image.asset('assets/logo.png', height: 40, width: 40),
            SizedBox(
              width: 10,
            ),
            Text("GUCircle")
          ]),
        ),
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 208, 59)),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddSheet(context),
        child: Image.asset(
          "assets/add.png",
        ),
      ),
      endDrawer: MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              selectedItem = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: "0",
              icon: Container(
                child: selectedItem == 0
                    ? Image.asset(
                        "assets/speak2.png",
                      )
                    : Image.asset(
                        "assets/speak3.png",
                        color: Colors.grey[600],
                      ),
                width: 30,
                height: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: "1",
              icon: Container(
                child: selectedItem == 1
                    ? Image.asset(
                        "assets/phone.png",
                      )
                    : Image.asset(
                        'assets/phone1.png',
                        color: Colors.grey[400],
                      ),
                width: 30,
                height: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: "2",
              icon: Container(
                child: selectedItem == 2
                    ? Image.asset(
                        "assets/lost-and-found3.png",
                      )
                    : Image.asset(
                        'assets/lost-and-found1.png',
                        color: Colors.grey[400],
                      ),
                width: 30,
                height: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: "3",
              icon: Container(
                child: selectedItem == 3
                    ? Image.asset(
                        "assets/placeholder.png",
                      )
                    : Image.asset(
                        'assets/maps-and-flags.png',
                        color: Colors.grey[400],
                      ),
                width: 30,
                height: 30,
              ),
            ),
          ]),
      body: _widgetOptions.elementAt(selectedItem),
    );
  }
}
