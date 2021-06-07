import 'package:flutter/material.dart';
import 'package:smart_study/Models/Post.dart';

class PostCard extends StatelessWidget {
  final Post post;


  PostCard({ this.post});



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network('http://localhost:3000/image/${post.image}'),
            Text(
              post.title,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 6.0,),
            Text(
              post.author,
              style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.grey[600]
              ),
            ),
            SizedBox(height: 10.0,),
            TextButton.icon(
              icon: Icon(Icons.read_more_sharp) ,
              label: Text("View details"),
            onPressed: () {

            },),
          ],
        ),
      ),
    );
  }
}
