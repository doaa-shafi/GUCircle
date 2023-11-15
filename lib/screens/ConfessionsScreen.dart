import 'package:flutter/material.dart';
import 'package:gucircle/post.dart';

class ConfessionsScreen extends StatelessWidget {
  List posts = [
    Post(
        id: "0",
        name: "hany",
        body: "abcbefghijklmnopqrstuvwxyz",
        likes: 15,
        comments: 40),
    Post(
        id: "0",
        name: "hany",
        body: "abcbefghijklmnopqrstuvwxyz",
        likes: 15,
        comments: 40),
    Post(
        id: "0",
        name: "hany",
        body: "abcbefghijklmnopqrstuvwxyz",
        likes: 15,
        comments: 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    hintText: "Write a post",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.cancel),
                    )),
              ),
            ),
            Divider(),
            Column(
                children: posts.map((post) {
              return Card(
                  child: Container(
                
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [Text(post.name)],
                    ),
                    Text(post.body),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Row(children: [
                                Icon(Icons.favorite,color: Colors.red[500],),
                                Text(post.likes.toString()),
                              ]),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Row(children: [
                                Icon(Icons.comment_rounded,color: Color.fromARGB(255, 255, 208, 0),),
                                Text(post.comments.toString()),
                              ]),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
            }).toList()),
          ],
        ),
      ),
    );
  }
}
