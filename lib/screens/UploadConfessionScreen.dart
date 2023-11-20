import 'dart:ffi';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UploadConfessionScreen extends StatefulWidget {
  const UploadConfessionScreen({super.key});

  @override
  State<UploadConfessionScreen> createState() =>
      _UploadLostAndFoundScreenState();
}

class _UploadLostAndFoundScreenState extends State<UploadConfessionScreen> {
  File? selectedImage;
  final lostItemDesc = TextEditingController();
  bool anonymous = false;
  changeAnonymous() => {
        setState(() {
          anonymous = !anonymous;
        })
      };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add confession')
      ,backgroundColor: Colors.black,),
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
                              labelText: 'What is your confession....',
                              border: InputBorder.none),
                          controller: lostItemDesc,
                        ),
                        SizedBox(height: 200,),
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
                                  child: anonymous?Text("anonymous"):Text("post it anonymously?"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
