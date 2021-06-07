import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class mainhome extends StatefulWidget {
  @override
  _mainhomeState createState() => _mainhomeState();
}


class _mainhomeState extends State<mainhome> {
  // ignore: deprecated_member_use, non_constant_identifier_names

  int _selectedIndex = 0;
  int _selectedItem = 0;
  // ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
         children: <Widget>[
           ClipPath(
             clipper: MyClipper(),
             child: Container(
               height: 350,
               width: double.infinity,
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                   colors: [
                     Colors.green,
                     Colors.blueGrey,
                   ]
                 )
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Align(
                     alignment: Alignment.topLeft,

                   ),
                   SizedBox(height: 20),
                   Expanded(child: Stack(
                     children: <Widget>[
                       Positioned(
                         width: 200 ,
                           height: 300,
                           top: 20,
                           left: 190,
                           child: Text(
                             "Smart Study l'application de vos reves.",
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 25,

                             ),
                           )),
                       Image.asset('assets/person.png', width: 400
                         ,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                       ),
                       Container(),
                     ],

                   ),
                   ),

                 ],
               ),
             ),
           ),
          Container(
             margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
            color: Color(0xFFE5E5E5),
            ),
            ),
          )
         ],
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
        defaultSelectedIndex: 1,
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
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
