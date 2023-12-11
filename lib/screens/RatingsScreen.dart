import 'package:flutter/material.dart';
import 'package:gucircle/components/MainAppBar.dart';
import 'package:gucircle/post.dart';
import 'package:gucircle/screens/CommentsScreen.dart';
import 'package:gucircle/screens/RatingsCommentsScreen.dart';
import 'package:gucircle/screens/UploadRatingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucircle/components/RatingCard.dart';

class RatingsSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  RatingsSearchBar({required this.onSearch});

  @override
  _RatingsSearchBarState createState() => _RatingsSearchBarState();
}

class _RatingsSearchBarState extends State<RatingsSearchBar> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          widget.onSearch(value);
        },
        decoration: InputDecoration(
          labelText: 'Search by Dr, TA, Course...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class RatingsScreen extends StatefulWidget {
  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  String searchQuery = '';
  List<dynamic> ratings = [];
  String query = '';

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('Ratings');

  Future<QuerySnapshot> fetchData() async {
    print('fetching data');
    QuerySnapshot snapshot = await collectionRef.get();
    ratings = [];
    snapshot.docs.forEach((document) {
      Map<String, dynamic> postData = document.data() as Map<String, dynamic>;
      postData['id'] = document.reference.id;
      ratings.add(postData);
    });

    ratings = ratings
        .where(
            (x) => x['ratedEntity'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return snapshot;
  }

  Future<String> getUsername(String userId) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    String username = userSnapshot.get('username');

    return username;
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  gotoUpload(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return UploadRatingScreen();
    }));
  }

  gotoComments(BuildContext myContext, String postId, List<dynamic> comments) {
    Navigator.of(myContext).push(MaterialPageRoute(builder: (ctxDummy) {
      return RatingsCommentsScreen(comments: comments, postId: postId);
    }));
  }

  void filterRatings(String q) {
    setState(() {
      query = q;
    });
  }

  List<dynamic> getFilteredData(List<dynamic> data) {
    return data
        .where(
            (x) => x['ratedEntity'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
          appBar: AppBar(),
          title: "Ratings",
          goBack: false,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          RatingsSearchBar(
            onSearch: filterRatings,
          ),
          RefreshIndicator(
            onRefresh: refreshData,
            child: FutureBuilder<QuerySnapshot>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                      backgroundColor: Colors.grey,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ratings.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          key:
                              UniqueKey(), // Add a UniqueKey to avoid rebuilding the list
                          itemCount: ratings.length,
                          itemBuilder: (context, index) {
                            final rating = ratings[index];
                            return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: RatingCard(
                                  postId: rating['id'],
                                  // eventDoc.reference.id.toString(),
                                  gotoComments: gotoComments,
                                  username: rating['ratedEntity'],
                                  comments: rating['ratings'],
                                  // usernameSnapshot.data.toString(),
                                  rating: rating['avgRating'],
                                  // comments: postData['ratings'],
                                ));
                          })
                      : Align(
                          heightFactor: 1.0,
                          alignment: Alignment.center,
                          child: Text(
                            'No Posts',
                            style: TextStyle(fontSize: 20),
                          ));
                }
              },
            ),
          ),
        ]));
  }
}
