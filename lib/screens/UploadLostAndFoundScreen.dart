import 'package:flutter/material.dart';

class UploadLostAndFoundScreen extends StatefulWidget {
  const UploadLostAndFoundScreen({super.key});

  @override
  State<UploadLostAndFoundScreen> createState() =>
      _UploadLostAndFoundScreenState();
}

class _UploadLostAndFoundScreenState extends State<UploadLostAndFoundScreen> {
  final lostItemDesc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: TextField(
          decoration:
              InputDecoration(labelText: 'What did you found and where'),
          controller: lostItemDesc,
        ),
      ),
    );
  }
}
