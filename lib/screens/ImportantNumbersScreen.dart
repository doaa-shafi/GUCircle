import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gucircle/components/mainAppBar.dart';
import '../number.dart';

class ImportantNumbersScreen extends StatefulWidget {
  @override
  _ImportantNumbersScreenState createState() => _ImportantNumbersScreenState();
}

class _ImportantNumbersScreenState extends State<ImportantNumbersScreen> {
  List<Number> numbers = [
    Number(id: "0", number: "00201092226442", name: "clinic"),
    Number(id: "1", number: "01012345678", name: "hospital"),
    Number(id: "3", number: "01012345678", name: "pharmacy"),
    Number(id: "4", number: "01012345678", name: "financial"),
    Number(id: "5", number: "01012345678", name: "student affairs"),
    Number(id: "6", number: "01012345678", name: "military affairs"),
    Number(id: "7", number: "01012345678", name: "admission"),
    Number(id: "8", number: "01012345678", name: "security"),
    Number(id: "8", number: "01012345678", name: "Academic affairs"),
  ];

  List<Number> filteredNumbers = [];
  TextEditingController searchController =
      TextEditingController(); // Controller for the search bar

  @override
  void initState() {
    super.initState();
    filteredNumbers.addAll(numbers);
  }

  void search() {
    setState(() {
      String query = searchController.text;
      filteredNumbers = numbers
          .where((num) => num.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear(); // Clear the search bar text
      search(); // Trigger search to update the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
          appBar: AppBar(), title: 'Important Numbers', goBack: true),
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
                    search(); // Trigger search on every change
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
                children: filteredNumbers.map((num) {
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
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
