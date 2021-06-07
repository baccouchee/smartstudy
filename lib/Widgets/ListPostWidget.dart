import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:smart_study/Models/Post.dart';
import 'package:smart_study/Pages/navBar.dart';
import 'package:smart_study/Widgets/DetailPostWidget.dart';
import 'package:smart_study/Widgets/EditPostWidget.dart';
import 'package:smart_study/services/PostApiService.dart';


class ListPost extends StatefulWidget {
  @override
  _ListPostState createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {

  bool isLoading = true;
  bool isAuthor = false;
  String username;
  String userId;
  List<Post> posts=[];
  final storage = new FlutterSecureStorage();
  final PostApiService api= new PostApiService();

  List<Post> parsePosts(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Future<void> fetchPosts() async {

    String value1 = await storage.read(key: "jwt");

    var formJson1 = json.decode(value1);
    print(formJson1['accessToken']);
    String value= formJson1['accessToken'];
    var listPayload = parseJwt(value).values.toList();
    print(listPayload[1]);
    bool test=false;
    String id = listPayload[0];
    if (listPayload[1]=="ROLE_ADMIN"){
      test = true;
    }
    final response = await get(Uri.http('10.0.2.2:3000','/post/$id'));
    posts= parsePosts(response.body);

    setState(()  {
      isLoading = false;
      isAuthor = test;
      userId = listPayload[0];
      username = listPayload[2];
    });

  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }




  String parseTime(String datetime) {
    //create datatime object
    DateTime now = DateTime.parse(datetime);
    String time = DateFormat.MMMMEEEEd().format(now);
    return time;
  }
  // Delete screen
  Future<void> _confirmDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async{
                await api.deleteCase(id);
                Navigator.pushReplacementNamed(context, "/home");
              },
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navBar(),
      appBar:AppBar(
        title: Text("My Posts"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blueGrey],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ) ,
      body: isLoading
          ? Center(child:CircularProgressIndicator(),)
          :ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailPage(lesson: posts[index],)),
                      );

                      //nothing for now
                    },
                    title: Text(posts[index].title,style: TextStyle(fontWeight: FontWeight.bold),),
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 60,
                        minHeight: 60,
                        maxWidth: 60,
                        maxHeight: 60,
                      ),
                      child: Image.network('http://10.0.2.2:3000/image/${posts[index].image}',),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Created by: ${posts[index].author}",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(parseTime(posts[index].dateAdded)),
                      ],

                    ),
                    trailing:
                        Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 20.0,
                            color: Colors.brown[900],
                          ),
                          onPressed: () async{
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditPost(userId: userId,username: username,postToEdit: posts[index],)),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            size: 20.0,
                            color: Colors.brown[900],
                          ),
                          onPressed: () {
                            _confirmDialog(posts[index].id);
                          },
                        ),
                      ],
                    )

                ),
              ),
            );
          }
      ),

    );
  }
}
