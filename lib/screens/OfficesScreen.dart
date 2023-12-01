import 'package:flutter/material.dart';
import 'package:gucircle/components/mainAppBar.dart';
import '../office.dart';

class OfficesScreen extends StatefulWidget {
  @override
  _OfficesScreenState createState() => _OfficesScreenState();
}

class _OfficesScreenState extends State<OfficesScreen> {
  List<Office> offices = [
    Office(
        id: "0",
        name: "DR Milad",
        location: "c7-201",
        directions: "Directions for c7-201"),
    Office(
        id: "1",
        name: "DR Mervat",
        location: "c7-202",
        directions: "Directions for c7-202"),
    Office(
        id: "2",
        name: "DR HYTHEM",
        location: "c7-203",
        directions: "Directions for c7-203"),
    Office(
        id: "3",
        name: "DR HYTHEM",
        location: "c7-203",
        directions: "Directions for c7-203"),
    Office(
        id: "4",
        name: "DR HYTHEM",
        location: "c7-203",
        directions: "Directions for c7-203"),
    Office(
        id: "5",
        name: "DR HYTHEM",
        location: "c7-203",
        directions: "Directions for c7-203"),
    Office(
        id: "6",
        name: "DR HYTHEM",
        location: "c7-203",
        directions: "Directions for c7-203"),
    Office(
        id: "7",
        name: "DR HYTHEM",
        location: "c7-203",
        directions: "Directions for c7-203"),
    Office(
        id: "8",
        name: "DR Amr",
        location: "c7-203",
        directions: "Directions for c7-203"),
  ];

  // Keep track of selected office for directions
  Office? selectedOffice;
  List<Office> filteredOffices = [];
  TextEditingController searchController =
      TextEditingController(); // Controller for the search bar

  @override
  void initState() {
    super.initState();
    filteredOffices.addAll(offices);
  }

  void search(String query) {
    setState(() {
      filteredOffices = offices
          .where((office) =>
              office.name.toLowerCase().contains(query.toLowerCase()) ||
              office.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear(); // Clear the search bar text
      filteredOffices = offices; // Reset filteredOffices to show all offices
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(appBar: AppBar(), goBack: true, title: 'Maps'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    search(value); // Trigger search on every change
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(width: 0.8),
                  ),
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: clearSearch,
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: filteredOffices.map((office) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle selected office
                            selectedOffice =
                                selectedOffice == office ? null : office;
                          });
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(office.name),
                            trailing: Text(office.location),
                          ),
                        ),
                      ),
                      if (selectedOffice == office)
                        Card(
                          child: ListTile(
                            title: Text("Directions"),
                            subtitle: Text(office.directions),
                          ),
                        ),
                      Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
