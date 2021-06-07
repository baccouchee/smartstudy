import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'InputDeco_design.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String name,email,phone,pass;

  //TextController to read text entered in text field
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<void> register() async{
    try {
      print("this is the email : - $email");
      print("this is the password : - $pass");
      String role;
      if(dropdownValue == "USER") {
        role = "ROLE_USER";
      }
      else {
        role = "ROLE_AUTHOR";
      }

        Response response = await post(
        Uri.http('10.0.2.2:3000', '/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },



        body: jsonEncode(<String, String>{
          'username': name,
          'email': email,
          'phone': phone,
          'password': pass,
          'role': role,

        }),
      );


      // Write value
      if(response.statusCode == 200) {

        print("The save is done");
        Navigator.pushReplacementNamed(context, "/login");

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

  String dropdownValue= "USER";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Stack(
                children: <Widget>[
                  Image(image: AssetImage("assets/headerlog.png")),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,30.0,20.0,0),
                        child: Text("Hello!",style: TextStyle(fontSize: 45.0,color: Colors.white),),
                      ),
                      SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,80.0,20.0,0),
                        child: Text("You can create an account from here",style: TextStyle(fontSize: 20.0,color: Colors.white38),),
                      ),
                    ],
                  ),


                ],
              ),
                Padding(
                  padding: const EdgeInsets.only(bottom:15,left: 10,right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person,"Username"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    onSaved: (String value){
                      name = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration:buildInputDecoration(Icons.email,"Email"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please Fill this field';
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                    onSaved: (String value){
                      email = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:buildInputDecoration(Icons.phone,"Phone No"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please enter a phone number ';
                      }
                      return null;
                    },
                    onSaved: (String value){
                      phone = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                  child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    decoration:buildInputDecoration(Icons.lock,"Password"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please Enter a Password';
                      }
                      return null;
                    },


                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    controller: confirmpassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration:buildInputDecoration(Icons.lock,"Confirm Password"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please re-enter password';
                      }
                      print(password.text);
                      pass = password.text;

                      print(confirmpassword.text);

                      if(password.text!=confirmpassword.text){
                        return "Password does not match";
                      }


                      return null;
                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                  child: DropdownButton<String>(

                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['USER', 'AUTHOR']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),


                  ),


                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.green[300],
                    onPressed: () async{

                      if(_formkey.currentState.validate())
                      {
                        _formkey.currentState.save();

                        await register();



                        return;
                      }else{

                      }
                    },
                    shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.white,width: 2)
                    ),
                    textColor:Colors.white,child: Text("Submit"),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
