import 'package:flutter/material.dart';
import 'package:smart_study/Pages/Home.dart';
import 'package:smart_study/Pages/Loading.dart';
import 'package:smart_study/Pages/SignIn.dart';
import 'package:smart_study/Pages/SignUp.dart';
import 'package:smart_study/Pages/Welcome.dart';

import 'package:smart_study/Pages/onbording.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Pages/HomeForm.dart';
import 'Pages/OneForm.dart';
import 'Pages/mainhome.dart';
import 'Pages/profile.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Poppins'
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/2': (context) => Home(),
      '/welcome': (context) => Welcome(),
      '/register': (context) => SignUp(),
      '/login': (context) => SignIn(),
      '/0': (context) => HomeForm(),
      '/1': (context) => mainhome(),
      '/profile': (context) => ProfileApp(),
      '/OneForm': (context) => OneForm(),
      '/oneboard': (context) => Onbording(),

    },
  ));
}


