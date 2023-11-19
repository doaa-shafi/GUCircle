import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UploadLostAndFoundScreen extends StatefulWidget {
  const UploadLostAndFoundScreen({super.key});

  @override
  State<UploadLostAndFoundScreen> createState() =>
      _UploadLostAndFoundScreenState();
}

class _UploadLostAndFoundScreenState extends State<UploadLostAndFoundScreen> {
  File ? selectedImage;
  final lostItemDesc = TextEditingController();
  Future pickImageFromGalary()async{
    final returenedImage =await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returenedImage==null) return;
    setState(() {
      selectedImage=File(returenedImage!.path);
    });
  }
  Future pickImageFromCamera()async{
    final returenedImage =await ImagePicker().pickImage(source: ImageSource.camera);
    if (returenedImage==null) return;
    setState(() {
      selectedImage=File(returenedImage!.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lost & Found'),
      backgroundColor: Colors.black,),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Color.fromARGB(255, 255, 208, 0))),
              child: TextField(
                decoration:
                    InputDecoration(labelText: 'What did you found/lost and where',border: InputBorder.none),
                controller: lostItemDesc,
              ),
            ),
            SizedBox(height: 20,),
            selectedImage!=null?Image.file(selectedImage!)
            :Column(
              children: [
                Text('Please upload an image for the found item'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: pickImageFromGalary, icon: FaIcon(FontAwesomeIcons.image,color: Colors.red,)),
                    IconButton(onPressed: pickImageFromCamera, icon: FaIcon(FontAwesomeIcons.camera,color: Colors.red,)),
                  ],
                ),
              ],
            ),
            ElevatedButton(onPressed: null, child: Text("Upload"))
          ],
        ),
      ),
    );
  }
}
