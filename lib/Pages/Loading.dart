import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void welcomePage () async{
    await Future.delayed(Duration(seconds: 4));
    Navigator.pushReplacementNamed(context, "/welcome");
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    welcomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
      body: SafeArea(
        child: Container(
          child: Center(
            child: SpinKitFadingCube(
              color: Colors.white,
              size: 70.0,
            ),
          ),

          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgload.png'),
                fit: BoxFit.cover,
              )
          ),

        ),


      )
    );
  }
}
