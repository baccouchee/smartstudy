import 'dart:io';

class Post{

  String id;
  String title;
  String content;
  String image;
  File imageContent;
  String author;
  String userID;
  String dateAdded;
  String tags;

  Post({this.id,this.title, this.content, this.image,this.author,this.userID,this.dateAdded,this.tags});
  Post.newPost({this.title, this.content, this.image,this.author,this.userID,this.tags,this.imageContent});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      image: json['image'] as String,
      author: json['author'] as String,
      userID: json['userID'] as String,
      dateAdded: json['dateAdded'] as String,
      tags: json['tags'] as String,
    );
  }

}

