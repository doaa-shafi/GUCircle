import 'dart:ffi';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadRatingScreen extends StatefulWidget {
  const UploadRatingScreen({super.key});

  @override
  State<UploadRatingScreen> createState() => _UploadRatingScreenState();
}

class _UploadRatingScreenState extends State<UploadRatingScreen> {
  File? selectedImage;
  String imgUrl = "";
  bool error = false;
  final postDesc = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  void removeImage() => setState(() {
        selectedImage = null;
      });

  Future<void> request() async {
    if (postDesc.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter description'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (selectedImage != null) {
      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('Imgs');
      Reference referenceImgToUpload = referenceDirImages.child(uniqueName);
      try {
        await referenceImgToUpload.putFile(selectedImage!);
        imgUrl = await referenceImgToUpload
            .getDownloadURL(); //get the image we uploaded
        error = false;
        print("Image uploaded successfully. Image URL: $imgUrl");
      } catch (e) {
        print("Error uploading image: $e");
        error = true;
      }
    }

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sending Request...'),
            content: Text('Please wait...'),
            actions: [],
          );
        },
      );
      User? user = FirebaseAuth.instance.currentUser;
      // String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
      if (user != null) {
        DocumentReference docRef =
            await firestore.collection('LostAndFound').add({
          'userId': user.uid,
          'text': postDesc.text,
          'imgURL': imgUrl,
          'likes': [],
          'comments': [],
          'date': DateTime.now()
        });
        await firestore.collection('Notifications').doc("all").update({
          'notifications': FieldValue.arrayUnion([
            {
              'message': "New Lost and Found post",
              'reference': docRef,
              "timestamp": Timestamp.now(),
            }
          ]),
        });
      }

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Request Successful'),
            content: Text('Posted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate back to the previous page
                  Navigator.of(context)
                      .popUntil((route) => route.settings.name == '/mainPage');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error sending request: $e");
      error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost & Found'),
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
                              labelText: 'What did you lose/find and where?',
                              border: InputBorder.none),
                          controller: postDesc,
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
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: request,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color.fromARGB(255, 107, 30, 24);
                          }
                          return const Color.fromARGB(255, 167, 46, 37);
                        }),
                      ),
                      child: Text(
                        "Post",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              error
                  ? const Text(
                      "An error occured, please try again later",
                      style: TextStyle(color: Colors.red),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
