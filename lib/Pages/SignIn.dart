import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_study/Components/rounded_button.dart';
import 'package:smart_study/Components/rounded_input_field.dart';
import 'package:smart_study/Components/rounded_password_field.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  var username;
  var password;


  // Create storage
  final storage = new FlutterSecureStorage();

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }



  Future<void> loginCheck() async{
    try {
      print("this is the email : - $username");
      print("this is the password : - $password");
      Response response = await post(
        Uri.http('10.0.2.2:3000', '/api/auth/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password
        }),
      );
      print(response.statusCode);
      storage.deleteAll();
      // Write value
      if(response.statusCode == 200) {
        await storage.write(key: 'jwt', value: response.body);

        print("The save is done");
        String value = await storage.read(key: "jwt");

        print("The value is $value");
        Navigator.pushReplacementNamed(context, '/oneboard');
      }
      else {
        showAlertDialog(context,response.body);
      }


    }
    catch(e)
    {
      print('caught error: $e');
    }

  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Stack(
                    children: <Widget>[
                      Image(image: AssetImage("assets/headerlog.png")),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,30.0,20.0,0),
                        child: Text("Welcome Back!",style: TextStyle(fontFamily: 'Poppins',fontSize: 40.0,color: Colors.white),),
                      ),
                      SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,80.0,20.0,0),
                        child: Text("Please login to your account",style: TextStyle(fontFamily: 'PoppinsLight', fontSize: 20.0,color: Colors.white38),),
                      ),


                    ],
                  ),
                    SizedBox(height: 50.0,),
                    RoundedInputField(
                      hintText: "Your Username",

                      onChanged: (value) {
                        username = value;
                      },
                    ),
                    RoundedPasswordField(
                      onChanged: (value) {
                        password= value;
                      },
                    ),

                    Center(

                      child : RoundedButton(
                        text: "LOGIN",
                        press: () async{
                          await loginCheck();
                          print("Done with the login action");
                        },

                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Center(

                      child : Text("Don’t have an Account ?" , style: TextStyle(fontFamily: 'PoppinsLight')),
                    ),
                    new GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: new Text("SIGN UP", style: TextStyle(fontFamily: 'PoppinsLight', fontSize: 15, color: Colors.blue)),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

showAlertDialog(BuildContext context,String text) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () { Navigator.of(context).pop();},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
