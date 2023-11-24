import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../number.dart';

class ImportantNumbersScreen extends StatelessWidget {
  List numbers = [
    Number(id: "0", number: "00201092226442", name: "clinic"),
    Number(id: "0", number: "01012345678", name: "clinic"),
    Number(id: "0", number: "01012345678", name: "clinic"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Important Numbers"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(width: 0.8)),
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.cancel),
                    )),
              ),
            ),
            Text(
              "Health",
              style: TextStyle(color: Color.fromARGB(255, 255, 208, 0)),
            ),
            Divider(),
            Column(
                children: numbers.map((num) {
              return GestureDetector(
                onTap: () async {
                  await FlutterPhoneDirectCaller.callNumber(num.number);
                },
                child: Card(
                  child: ListTile(
                    title: Text(num.name),
                    trailing: Text(num.number),
                  ),
                ),
              );
            }).toList()),
            Divider(),
            Text(
              "IT",
              style: TextStyle(color: Color.fromARGB(255, 255, 208, 0)),
            ),
            Divider(),
            Column(
                children: numbers.map((num) {
              return Card(
                child: ListTile(
                  title: Text(num.name),
                  trailing: Text(num.number),
                ),
              );
            }).toList()),
            Divider(),
            Text(
              "hotlines",
              style: TextStyle(color: Color.fromARGB(255, 255, 208, 0)),
            ),
            Divider(),
            Column(
                children: numbers.map((num) {
              return Card(
                child: ListTile(
                  title: Text(num.name),
                  trailing: Text(num.number),
                ),
              );
            }).toList()),
            Divider(),
          ],
        ),
      ),
    );
  }
}
