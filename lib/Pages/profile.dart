import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_study/Components/rounded_button.dart';

class ProfileApp extends StatefulWidget {
  @override
  _ProfileApp createState() => _ProfileApp();
}

class Resp{
  String nom;
  String id;
  String idForm;
  List<String> rep;
  String idUser;
  double prixrep;
  Resp(this.id, this.nom,  this.idForm, this.rep, this.idUser, this.prixrep);

  Resp.formJson(Map<String,dynamic> json){
    id = json['_id'];
    nom = json['nom'];
    idForm = json['idForm'];
    idUser = json['idUser'];
    rep = new List<String>.from(json['rep']);
    prixrep = json['prixrep'];
  }
}

class _ProfileApp extends State<ProfileApp> {


  final storage = new FlutterSecureStorage();

  List<User> _User = <User>[];
  List<Resp> _Resp = <Resp>[];
  int nbrReponses;
int nbrPosts;
  String idUser;
  double prix=0;
  String number ;
  Future<List<Resp>> prixcount() async{
    String value = await storage.read(key: "jwt");
    var formJson = json.decode(value);
    print(value);
    idUser = User.formJson(formJson).id;
    print('idUser : $idUser');


    var response = await http.get(Uri.http('10.0.2.2:3000', '/prix/'+idUser));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    var resp = <Resp>[];
    if(response.statusCode == 200) {
      print('ouiii');
      var formJson = json.decode(response.body);
      for (var formJson in formJson) {

        resp.add(Resp.formJson(formJson));
        //prix = Resp.formJson(formJson).prixrep ++;
        //print(prix);
      }


    }
    else print('boob');
    return resp;


  }


  Future<List<User>> UserDetails() async{
    String value = await storage.read(key: "jwt");
    var formJson = json.decode(value);
    print(value);
    idUser = User.formJson(formJson).id;
    print('idUser : $idUser');


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


  Future<List<User>> nbrReponse() async{
    String value = await storage.read(key: "jwt");
    var formJson = json.decode(value);
    print(value);
    idUser = User.formJson(formJson).id;
    print('idUser : $idUser');

    var response = await http.get(Uri.http('10.0.2.2:3000', '/count/'+idUser));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    var users;
    if(response.statusCode == 200) {
      users = json.decode(response.body);

      setState(() {
        nbrReponses = users;
        print(nbrReponses);
      });

    }
    else print('boob');
  }


  Future<List<Form>> nbrPostss() async{
    String value = await storage.read(key: "jwt");
    var formJson = json.decode(value);
    print(value);
    idUser = User.formJson(formJson).id;
    print('idUser : $idUser');


    var response = await http.get(Uri.http('10.0.2.2:3000', '/countPosts/'+idUser));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    var users;
    if(response.statusCode == 200) {
      users = json.decode(response.body);

      setState(() {
        nbrPosts = users;
        print(nbrPosts);
      });

    }
    else print('boob');
  }


  @override
  void initState(){
    UserDetails().then((value) {
      setState(() {

        _User.addAll(value);
      });

    });

    prixcount().then((value) {
      setState(() {

        _Resp.addAll(value);

      });
      for(int i=0; i<_Resp.length; i++){
        print(_Resp[i].prixrep);
        prix += _Resp[i].prixrep ;

      }
     // ignore: unnecessary_statements
     number = prix.toStringAsFixed(2);

    });

    nbrReponse();
    nbrPostss();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
    itemCount:1,
    itemBuilder: (context,index) {
      return Column(

        children: <Widget>[

          Container(

              decoration: BoxDecoration(

                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        'assets/bgload.png')),
              ),
              child: Container(

                width: double.infinity,
                height: 300.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        width: 380.0,
                        child:     IconButton(
                          alignment: Alignment.topLeft,
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),



                      SizedBox(
                        height: 10.0,
                      ),


                      Text(
                        _User[index].username,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsLight'
                        ),
                      ),

                      Text(
                          _User[index].email,
                        style: TextStyle(
                            fontSize: 19.0,
                            color: Colors.white,
                            fontFamily: 'PoppinsLight'

                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(

                                  children: <Widget>[
                                    Icon(Icons.article, color: Colors.green,),
                                    Text(
                                      "Posts",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PoppinsLight'
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),

                                    Text(
                                      nbrPosts.toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blueGrey,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(

                                  children: <Widget>[
                                    Icon(Icons.add_circle, color: Colors.green,),
                                    Text(
                                      "Reponses",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PoppinsLight'
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      nbrReponses.toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blueGrey,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(

                                  children: <Widget>[
                                    Icon(Icons.monetization_on, color: Colors.green,),
                                    Text(
                                      "Pocket",

                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PoppinsLight'
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      number +'DT',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blueGrey,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 30.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Bio :",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.green,
                        fontSize: 28.0

                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    _User[index].description,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontFamily: 'PoppinsLight'
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),


     RoundedButton(
      text: "BE PRO",
      press: () async{
      print("Done with the login action");
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
    description = json['description'];

  }
}