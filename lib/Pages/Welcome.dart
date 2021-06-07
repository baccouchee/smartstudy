import 'package:flutter/material.dart';
import 'package:smart_study/Components/rounded_button.dart';
class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.blueGrey, Colors.green],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0,50.0,30.0,0),
              child: Image(image: AssetImage("assets/logo.png"),
                height: 80.0,
                width: 400.0,
              ),
            ),
            SizedBox(height: 40.0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,8.0,8.0,0),
              child: Text(
                "Excited ?",style: TextStyle(fontSize: 35.0,  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  foreground: Paint()..shader = linearGradient),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,0,0.0,0),
              child: Text(
                "You should be",style: TextStyle(fontSize: 30.0,   fontWeight: FontWeight.bold,
                  fontFamily: 'PoppinsLight',
                  foreground: Paint()..shader = linearGradient),
              ),
            ),


            SizedBox(height: 40.0,),
            Center(child:Text("Sign in if you already have an account",style: TextStyle(fontFamily: 'PoppinsLight',fontSize: 15.0),)
            ),

            Center(

              child : RoundedButton(
                text: "LOGIN",
                press: () {
                  Navigator.pushNamed(context, "/login");
                },

              ),
            ),
            SizedBox(height: 40.0,),
            Center(child:Text("Or Sign up if you are new!",style: TextStyle(fontFamily: 'PoppinsLight',fontSize: 15.0),)
            ),

            Center(

              child : RoundedButton(
                text: "SIGN UP",
                color: Colors.green[900],
                press: () {
                  Navigator.pushNamed(context, "/register");
                },

              ),

            ),
            SizedBox(height: 150.0,),
            Center(
              child: Text(
                "www.smartstudy.com",style: TextStyle(fontSize: 15.0,
                  fontFamily: 'PoppinsLight',
                  color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
