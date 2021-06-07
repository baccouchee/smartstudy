import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_study/Widgets/AddPostWidget.dart';
import 'package:smart_study/Widgets/ListPostWidget.dart';


class navBar extends StatefulWidget {
  @override
  _navBar createState() => _navBar();
}





class _navBar extends State<navBar> {

  final storage = new FlutterSecureStorage();

  List<User> _User = <User>[];
  String idUser;
  bool isAuthor= false;
String username;
  Future<List<User>> UserDetails() async{
    String value = await storage.read(key: "jwt");
    var formJson = json.decode(value);
    print(value);
    username = formJson['username'];
    idUser = User.formJson(formJson).id;
    print('idUser : $idUser');
    String value1 = await storage.read(key: "testAuth");
    print(value1);

    if (value1=="ROLE_ADMIN"){
      setState(() {
        isAuthor = true;
      });
    }

    var response = await http.get(Uri.http('10.0.2.2:3000', '/users/'+idUser));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    var users = <User>[];
    if(response.statusCode == 200) {
      print('ouiii');
      var formJson = json.decode(response.body);
      print(formJson);
      users.add(User.formJson(formJson));

    }
    else print('boob');
    return users;


  }

  _navigateToAddScreen (BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPostWidget(userId: idUser,username: username,)),
    );

  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.blueGrey, Colors.green],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  @override
  void initState(){
    UserDetails().then((value) {
      setState(() {

        _User.addAll(value);
      });

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        // Remove padding
        padding: EdgeInsets.zero,
          itemCount:_User.length,
        itemBuilder: (context,index) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
          UserAccountsDrawerHeader(

            accountName: Text(_User[index].username),
            accountEmail: Text(_User[index].email),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.blueGrey],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      'assets/headerlog1.png')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, "/1");
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
                ListTile(
                  leading: Icon(Icons.article),
                  title: Text('Article'),
                  onTap: ()  {
                    Navigator.pushNamed(context, "/2");
                  }
                ),
                ListTile(
                  leading: Icon(Icons.scatter_plot_rounded),
                  title: Text('Forms'),
                  onTap: () {
                    Navigator.pushNamed(context, "/0");
                  }


                ),

                Divider(),
          ListTile(
            leading: isAuthor ? Icon(Icons.settings) : null,
            title: isAuthor ? Text('Manage Articles'):null,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPost()),
              );

            },
          ),
          ListTile(
            leading: isAuthor ? Icon(Icons.add_circle):null,
            title: isAuthor ? Text('Add Article'):null,
            onTap: ()  {
             _navigateToAddScreen(context);

            }
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
          );
        }

    )
    );
  }
}

class User{
  String username;
  String description;
  String id;

  String email;

  User(this.id, this.username, this.email);

  User.formJson(Map<String,dynamic> json){
    id = json['id'];
    username = json['username'];
    email = json['email'];

  }
}

