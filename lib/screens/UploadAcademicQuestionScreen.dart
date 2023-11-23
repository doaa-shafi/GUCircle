import 'dart:ffi';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UploadAcademicQuestionScreen extends StatefulWidget {
  const UploadAcademicQuestionScreen({super.key});

  @override
  State<UploadAcademicQuestionScreen> createState() =>
      _UploadLostAndFoundScreenState();
}

class _UploadLostAndFoundScreenState
    extends State<UploadAcademicQuestionScreen> {
  File? selectedImage;
  Future pickImageFromGalary() async {
    final returenedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returenedImage == null) return;
    setState(() {
      selectedImage = File(returenedImage!.path);
    });
  }

  Future pickImageFromCamera() async {
    final returenedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returenedImage == null) return;
    setState(() {
      selectedImage = File(returenedImage!.path);
    });
  }

  final lostItemDesc = TextEditingController();
  String category = "";
  bool anonymous = false;
  changeAnonymous() => {
        setState(() {
          anonymous = !anonymous;
        })
      };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Have a question..?'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                              labelText: 'What is your question....',
                              border: InputBorder.none),
                          controller: lostItemDesc,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        selectedImage != null
                            ? Image.file(selectedImage!)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: pickImageFromGalary,
                                      icon: FaIcon(
                                        FontAwesomeIcons.image,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: pickImageFromCamera,
                                      icon: FaIcon(
                                        FontAwesomeIcons.camera,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => {
                                setState(() {
                                  category = "Courses";
                                })
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: category == "Courses"
                                            ? Colors.white
                                            : Color.fromARGB(255, 255, 208, 0)),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: category == "Courses"
                                        ? Color.fromARGB(50, 255, 208, 0)
                                        : Colors.white),
                                child: Text(
                                  "Courses",
                                  style: TextStyle(
                                      color: category == "Courses"
                                          ? const Color.fromARGB(
                                              255, 255, 208, 0)
                                          : const Color.fromARGB(
                                              255, 255, 208, 0),
                                      fontWeight: category == "Courses"
                                          ?FontWeight.bold
                                          :FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => {
                                setState(() {
                                  category = "Stuff";
                                })
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: category == "Stuff"
                                            ? Colors.white
                                            : Color.fromARGB(255, 255, 208, 0)),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: category == "Stuff"
                                        ? const Color.fromARGB(150, 255, 208, 0)
                                        : Colors.white),
                                child: Text(
                                  "Stuff",
                                  style: TextStyle(
                                      color: category == "Stuff"
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 255, 208, 0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => {
                                setState(() {
                                  category = "Books";
                                })
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: category == "Books"
                                            ? Colors.white
                                            : Color.fromARGB(255, 255, 208, 0)),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: category == "Books"
                                        ? const Color.fromARGB(150, 255, 208, 0)
                                        : Colors.white),
                                child: Text(
                                  "Books",
                                  style: TextStyle(
                                      color: category == "Books"
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 255, 208, 0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () => {changeAnonymous()},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: anonymous
                                    ? Image.asset(
                                        "assets/silent.png",
                                      )
                                    : Image.asset(
                                        "assets/silent1.png",
                                      ),
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(20, 6, 20, 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: anonymous
                                      ? Text("anonymous")
                                      : Text("post it anonymously?"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: null,
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.red[500];
                    }
                    return Colors.red[500];
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
