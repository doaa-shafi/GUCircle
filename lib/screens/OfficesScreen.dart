import 'package:flutter/material.dart';
import '../office.dart';

class OfficesScreen extends StatelessWidget {
  List offices = [
    Office(id: "0", name: "dr", location: "c7-201"),
    Office(id: "0", name: "dr", location: "c7-201"),
    Office(id: "0", name: "dr", location: "c7-201")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offices and outlets'),
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
              "Academic stuff offices",
              style: TextStyle(color: Color.fromARGB(255, 255, 208, 0)),
            ),
            Divider(),
            Column(
                children: offices.map((office) {
              return Card(
                child: ListTile(
                  title: Text(office.name),
                  trailing: Text(office.location),
                ),
              );
            }).toList()),
            Divider(),
            Text(
              "Affairs offices",
              style: TextStyle(color: Color.fromARGB(255, 255, 208, 0)),
            ),
            Divider(),
            Column(
                children: offices.map((office) {
              return Card(
                child: ListTile(
                  title: Text(office.name),
                  trailing: Text(office.location),
                ),
              );
            }).toList()),
            Divider(),
            Text(
              "Food outlets",
              style: TextStyle(color: Color.fromARGB(255, 255, 208, 0)),
            ),
            Divider(),
            Column(
                children: offices.map((office) {
              return Card(
                child: ListTile(
                  title: Text(office.name),
                  trailing: Text(office.location),
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
