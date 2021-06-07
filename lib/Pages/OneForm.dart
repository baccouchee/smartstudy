import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class OneForm extends StatefulWidget {
  @override
  _OneForm createState() => _OneForm();
}

class Form{
  String nom;
  String description;
  String id;

  List<String> question;
  String img;
  int reviews;
  double prix;
  Form(this.id, this.nom, this.description, this.question, this.img, this.reviews, this.prix);

  Form.formJson(Map<String,dynamic> json){
    id = json['_id'];
    nom = json['nom'];
    question = new List<String>.from(json['quest']);
    description = json['description'];
    img = json['img'];
    reviews = json['reviews'];
    prix = json['prix'];
  }
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


class User{
  String id;

  User(this.id);

  User.formJson(Map<String,dynamic> json){
    id = json['id'];
  }
}

class _OneForm extends State<OneForm> {

  FlutterLocalNotificationsPlugin localNotificationsPlugin;

  // ignore: deprecated_member_use, non_constant_identifier_names
int rev;
  List<Form> _Form = <Form>[];
String text;
int index1;
String nom;
String idForm;
double prix;
  bool _validate = false;
String idUser;
// ignore: deprecated_member_use
  FToast fToast;
List rep = [];
  List<String> questionn;
String reponse;
  final storage = new FlutterSecureStorage();

  List<TextEditingController> myController = [];
  List<TextEditingController> _controller = [
    for (int i = 0; i <20; i++)
      TextEditingController()
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller[questionn.length].dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  Future<List<Form>> QuestionList() async{
    String value = await storage.read(key: "_idd");
    print(value);

    var response = await http.get(Uri.http('10.0.2.2:3000', '/form/'+value));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    var formes = <Form>[];
    if(response.statusCode == 200) {
      print('ouiii');
      var formJson = json.decode(response.body);
      print(formJson);
      formes.add(Form.formJson(formJson));
    }
else print('boob');
    return formes;


  }

  Future<void> reps() async{

    String value1 = await storage.read(key: "jwt");
    var formJson = json.decode(value1);
    print('idUser2 : $value1');
    print('idUser1 : $formJson');
    idUser = User.formJson(formJson).id;
    print('idUser : $idUser');
    Map<String, dynamic> args = {'nom': nom, "rep": rep, "idForm": idForm, "idUser" : idUser, "prixrep" : prix};
    //Map<String, dynamic> args1 = {'reviews': rev+1};
    var body = json.encode(args);
    //var body1 = json.encode(args1);


    try {
      Response response = await
          post(Uri.http('10.0.2.2:3000', '/cresp'), body: body, headers: {'Content-type': 'application/json'});
      print(response.statusCode);
      // Write value
      if(response.statusCode == 200) {
        try {
          print('yeeeeesssssss <3');
        }
        catch(e)
        {
          print('caught error: $e');
        }
        print("The save is done");
        rep.clear();
        _showNotification();
        Navigator.pushReplacementNamed(context, "/0");

      }
      else if(response.statusCode == 202) {

        _showToast("vous avez déjà rempli ce questionnaire !");

      }


    }
    catch(e)
    {
      print('caught error: $e');
    }

  }

  @override
  void initState(){

    QuestionList().then((value) {
      setState(() {

        _Form.addAll(value);
      });

    });

    fToast = FToast();
    fToast.init(context);



    super.initState();

    var androidInitialize = new AndroidInitializationSettings('app_icon');
var iOSIntialize = new IOSInitializationSettings();
var initializeSetting = new InitializationSettings(android : androidInitialize, iOS: iOSIntialize);
    localNotificationsPlugin = new FlutterLocalNotificationsPlugin();
localNotificationsPlugin.initialize(initializeSetting);

  }

  Future _showNotification() async{
    var androidDetails = new AndroidNotificationDetails("channelId", "channelName", "channelDescription", importance: Importance.high);;
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(android: androidDetails, iOS:  iosDetails);
    await localNotificationsPlugin.show(0, nom, "Merci d'avoir remplie le formulaire !", generalNotificationDetails);
  }

  _showToast(String rep) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.clear),
          SizedBox(
            width: 12.0,
          ),
          Text(rep),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );

  }


  @override
  Widget build(BuildContext context) {
    int _selectedItem = 0;

    final Shader linearGradient = LinearGradient(
      colors: <Color>[Colors.blueGrey, Colors.green],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


    return Scaffold(
      appBar: AppBar(
        title: Text('SmartStudy'),
        //centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/0");
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
        //backgroundColor: Colors.purple,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blueGrey],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),

      ),



      backgroundColor: Colors.white,
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
        itemCount:_Form.length,
        itemBuilder: (context,index) {
          questionn = _Form[index].question;
          nom = _Form[index].nom;
          rev = _Form[index].reviews;
          idForm = _Form[index].id;
          prix = _Form[index].prix;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 10.0),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: NetworkImage(
                          'http://10.0.2.2:3000/image/' + _Form[index].img),
                      fit: BoxFit.cover,
                    ),
                  )),
              Center(child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(nom,

                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        foreground: Paint()..shader = linearGradient
                    ),
                  )
              )
              ),

              Center(child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(_Form[index].description,
                      style: TextStyle(fontSize: 20, color: Colors.black54,   )
                  )
              )
              ),
              Center(child: Wrap(
                children: List.generate(questionn.length, (index) {
                  return Column(

                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(questionn[index].toString(), style: TextStyle(
                            fontSize: 17, color: Colors.black, fontFamily: 'PoppinsLight') ),
                        SizedBox(height: 10),
                        TextFormField(
                            controller: _controller[index],
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              setState(() {
                                _validate = true;
                              });
                            }
                            return null;
                          },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              //errorText: _validate ? 'Text Can\'t Be Empty' : null,
                            ),
                        )
                      ]

                  );
                }
                ),
              ),
              ),
              SizedBox(height: 30),
              Center(child:       Container(
                height: 50.0,
                margin: const EdgeInsets.only(bottom: 30.0),
                child: RaisedButton(
                  onPressed: () async {

                    for (int i=0; i <questionn.length; i++){
                      rep.add(_controller[i].text);
                      setState(() {
                        _controller[i].text.isEmpty ? _validate = true : _validate = false;
                      });
                    }

                    print(rep);

                    if (_validate == false)
                      {
                        await reps();
                      }
                    else
                      {
                        _showToast("Veulliez remplir correctement le formulaire!");
                        rep.clear();
                      }


                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueGrey, Colors.green],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Container(
                      constraints:
                      BoxConstraints(maxWidth: 150.0, minHeight: 25.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Valider",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ),
             ),


            ],

          );
        })

          );
        }



  }


