import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_study/Pages/navBar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';


class HomeForm extends StatefulWidget {
  @override
  _HomeForm createState() => _HomeForm();
}

class Categories{
  String nom;
  String id;

  Categories(this.id, this.nom);

  Categories.formJson(Map<String,dynamic> json){
    id = json['_id'];
    nom = json['nom'];
  }
}


class Resp{
  String nom;
  String id;
  String idForm;
  List<String> rep;

  Resp(this.id, this.nom,  this.idForm, this.rep);

  Resp.formJson(Map<String,dynamic> json){
    id = json['_id'];
    nom = json['nom'];
    idForm = json['idForm'];
    rep = new List<String>.from(json['rep']);
  }
}

class Forms{
  String nom;
  String description;
  String id;
  String img;
String cat;
  Forms(this.id, this.nom, this.description, this.img, this.cat);

  Forms.formJson(Map<String,dynamic> json){
    id = json['_id'];
    nom = json['nom'];
    description = json['description'];
    img = json['img'];
    cat = json['cat'];


  }
}

class _HomeForm extends State<HomeForm> {
  // ignore: deprecated_member_use, non_constant_identifier_names
  List<Forms> _Form = <Forms>[];
  List<Categories> _Cat = <Categories>[];
  List<Resp> _Resp = <Resp>[];
  int nbrResp1;
  String _id;
  Double prct;
  String rev ="2";
  List<int> repp =<int>[];
String catt;

  List<Forms> _FormDisplay = <Forms>[];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'SmartStudy' );
  String _searchText = "";



  final TextEditingController _filter = new TextEditingController();
  final storage = new FlutterSecureStorage();
  final myController = TextEditingController();









  Future<List<User>> nbrReponse(idForm) async{
    var response = await http.get(Uri.http('10.0.2.2:3000', '/countForm/'+ idForm));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    if(response.statusCode == 200) {
      var formJson = json.decode(response.body);
      print(formJson);

      setState(() {
        repp.add(formJson);
        print(repp);
      });

    }
    else print('boob');

  }



  Future<List<Categories>> CatList() async{
    var response = await http.get(Uri.http('10.0.2.2:3000', '/cat'));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    var cats = <Categories>[];
    if(response.statusCode == 200) {
      var formJson = json.decode(response.body);
      for (var formJson in formJson) {
        cats.add(Categories.formJson(formJson));
      }

    }

    return cats;


  }


  Future<List<Forms>> formList(cat) async{
    var response = await http.get(Uri.http('10.0.2.2:3000', '/formcat/' + cat));
    print(response.statusCode);
    //Response status code (200)
    // ignore: deprecated_member_use
    var formcat = <Forms>[];
    if(response.statusCode == 200) {
      var formJson = json.decode(response.body);
      for (var formJson in formJson) {

        formcat.add(Forms.formJson(formJson));
        await nbrReponse(Forms.formJson(formJson).id);
      }

    }

    return formcat;


  }
  // ignore: non_constant_identifier_names
  Future<List<Forms>> QuestionList() async{

      var response = await http.get(Uri.http('10.0.2.2:3000', '/form'));
      print(response.statusCode);
      //Response status code (200)
      // ignore: deprecated_member_use
      var formes = <Forms>[];
      if(response.statusCode == 200) {
        var formJson = json.decode(response.body);
        for (var formJson in formJson) {

          formes.add(Forms.formJson(formJson));
          await nbrReponse(Forms.formJson(formJson).id);

        }

      }

      return formes;


    }



    @override
void initState(){
    QuestionList().then((value) {
      setState(() {

        _Form.addAll(value);
        _FormDisplay = _Form;
      });

    });


    CatList().then((value) {
      setState(() {

        _Cat.addAll(value);
      });

    });


//var androidIntitialize = new AndroidInitializationSettings(defaultIcon)
    super.initState();
}




@override
  List<String> categories = ['Page 0qsdqsdqsqsdqssdddqsd', 'Page 1', 'Page 2'];
  int initPosition = 1;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.blueGrey, Colors.green],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context){
    int _selectedIndex = 0;
    int _selectedItem = 0;


    return DefaultTabController(
      length: _Cat.length,
        child: Scaffold(
          drawer: navBar(),
      appBar: AppBar(
        title: _appBarTitle,


        //centerTitle: true,

        actions: [
      
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),

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
            bottom: new TabBar(
              isScrollable: true,
              indicatorWeight: 4.0,
              indicatorColor:Color(0xffffffff),
              unselectedLabelColor: Colors.greenAccent,
    tabs: List<Widget>.generate(_Cat.length, (int index){

    return new Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(_Cat[index].nom),
      ),
    );

    }

    ),
              onTap: (index) {
                _FormDisplay.clear();
                repp.clear();
                print(_Cat[index].nom);

                formList(_Cat[index].nom);
                formList(_Cat[index].nom).then((value) {
                  setState(() {

                    _FormDisplay.addAll(value);
                  });

                });
            },
            ),
      ),






      bottomNavigationBar: CustomBottomNavigationBar(
        iconList: [
          Icons.scatter_plot_rounded,
          Icons.home,
          Icons.article,

        ],
        onChange: (val) {
          setState(() {
            _selectedItem = val;
            print(_selectedItem.toString());
            Navigator.pushReplacementNamed(context, "/" + _selectedItem.toString());
            });
        },
        defaultSelectedIndex: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(

        itemBuilder: (context,index) {
          return index == 0 ? _SearchBar() : _listItem(index-1);
        },
        itemCount:_FormDisplay.length+1,
      ),

      ),

    );


  }
  _SearchBar(){
return Padding(padding: const EdgeInsets.all(8.0),
  child: TextField(
    decoration: InputDecoration(

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.all(
              Radius.circular(30.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)),
        ),
        suffixIcon: Icon(
          Icons.search,
          color: Colors.green,
        ),
      hintText: 'Search ...'
    ),
    onChanged: (text){
      text = text.toLowerCase();
setState(() {
  _FormDisplay = _Form.where((form) {
    var formTitle = form.nom.toLowerCase();
    return formTitle.contains(text);
  }).toList();
});
    }

  ),
);
  }

  _listItem(index){
    _id = _FormDisplay[index].id;



    return      Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),

      clipBehavior: Clip.antiAlias,
      child: Column(

        children: [

          Container(
              padding: EdgeInsets.only(right: 16.0),
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image:  NetworkImage('http://10.0.2.2:3000/image/' + _FormDisplay[index].img),
                  fit: BoxFit.cover,
                ),
              )),

          ListTile(

            title: Text(_FormDisplay[index].nom,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  foreground: Paint()..shader = linearGradient
              ),
            ),
            subtitle: Text(
              _FormDisplay[index].cat,
              style: TextStyle(color: Colors.black.withOpacity(0.6),
                  fontSize: 17,
                  fontFamily: 'PoppinsLight'),
            ),
          ),
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('reviews ' + repp[index].toString() , style: TextStyle(color: Colors.black.withOpacity(0.6), fontFamily: 'PoppinsLight')),
              Text("samedi, 24 avril 2021" , style: TextStyle(color: Colors.black.withOpacity(0.6), fontFamily: 'PoppinsLight')),
              //your widgets here...
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 5.0,
                animation: true,
                percent: double.parse(repp[index].toString()) / 100, // here we're using the percentage to be in sync with the color of the text
                center: new Text(
                  repp[index].toString() + "%",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0),
                ),
                backgroundColor: Colors.grey[300],
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.green,
              )

            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _FormDisplay[index].description,
              style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
            ),
          ),
          Container(
            height: 50.0,
            margin: const EdgeInsets.only(bottom: 30.0),
            child: RaisedButton(
              onPressed: () async{
                await storage.write(key: '_idd', value: _FormDisplay[index].id);
                String value = await storage.read(key: "_idd");
                print(value);
                Navigator.pushReplacementNamed(context, "/OneForm");
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
                    "Consulter",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

}

class CustomBottomNavigationBar extends StatefulWidget {
  PageController _pageController;
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
        @required this.iconList,
        @required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i));
    }

    return Row(
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {

        widget.onChange(index);

        setState(() {

          _selectedIndex = index;

        });
      },
      child: Container(
        height: 60,
        width: MediaQuery
            .of(context)
            .size
            .width / _iconList.length,
        decoration: index == _selectedIndex
            ? BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 4, color: Colors.green),
            ),
            gradient: LinearGradient(colors: [
              Colors.green.withOpacity(0.3),
              Colors.green.withOpacity(0.015),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
          // color: index == _selectedItemIndex ? Colors.green : Colors.white,
        )
            : BoxDecoration(),
        child: Icon(
          icon,
          color: index == _selectedIndex ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

}



