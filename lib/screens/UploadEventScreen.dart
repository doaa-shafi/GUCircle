import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadEventScreen extends StatefulWidget {
  const UploadEventScreen({super.key});

  @override
  State<UploadEventScreen> createState() => _UploadLostAndFoundScreenState();
}

class _UploadLostAndFoundScreenState extends State<UploadEventScreen> {
  File? selectedImage;
  String imgUrl = "";
  bool error = false;

  Future pickImageFromGalary() async {
    final returenedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returenedImage == null) return;
    setState(() {
      selectedImage = File(returenedImage.path);
    });
  }

  Future pickImageFromCamera() async {
    final returenedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returenedImage == null) return;
    setState(() {
      selectedImage = File(returenedImage.path);
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

  void removeImage() => setState(() {
        selectedImage = null;
      });

  Future<void> request() async {
    if (selectedImage != null) {
      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('EventImgs');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
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
                              labelText: 'What is your event?',
                              border: InputBorder.none),
                          controller: lostItemDesc,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        selectedImage != null
                            ? Column(
                                children: [
                                  Image.file(selectedImage!),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.red,
                                    onPressed: removeImage,
                                  )
                                ],
                              )
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: request,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(255, 190, 52, 42);
                    }
                    return Colors.red[500];
                  }),
                ),
                child: Text(
                  "Request Approval",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
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
