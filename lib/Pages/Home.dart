import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:smart_study/Models/Post.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_study/Pages/CustomDrawer.dart';
import 'package:smart_study/Widgets/AddPostWidget.dart';
import 'package:smart_study/Widgets/DetailPostWidget.dart';
import 'package:smart_study/Widgets/ListPostWidget.dart';
import 'package:smart_study/services/PostApiService.dart';

import 'navBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {

  bool isLoading = true;
  bool isAuthor = false;
  String username;
  String userId;

  final storage = new FlutterSecureStorage();
  final PostApiService api= new PostApiService();

  // A function that converts a response body into a List<Posts>.
  List<Post> parsePosts(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  }

  Future<void> fetchPosts() async {
    final response = await get(Uri.http('10.0.2.2:3000','/posts'));
    posts= parsePosts(response.body);
    String value1 = await storage.read(key: "jwt");
    var formJson1 = json.decode(value1);
    print(formJson1['accessToken']);
    String value= formJson1['accessToken'];
    var listPayload = parseJwt(value).values.toList();
    print(listPayload[2]);

    await storage.write(key: 'testAuth', value: listPayload[2]);


    bool test=false;
    if (listPayload[2]=="ROLE_ADMIN"){
      test = true;
    }

    setState(()  {
      isLoading = false;
      isAuthor = test;
      userId = listPayload[0];
      username = listPayload[2];
    });

  }

  String parseTime(String datetime) {
    //create datatime object
    DateTime now = DateTime.parse(datetime);
   String time = DateFormat.MMMMEEEEd().format(now);
   return time;
  }

  List<Post> posts=[];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }


  @override
  Widget build(BuildContext context) {

    int _selectedItem = 0;

    return Scaffold(
        drawer: navBar(),
      appBar: AppBar(
        title: Text("Post List"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blueGrey],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: isLoading
          ? Center(child:CircularProgressIndicator(),)
          :ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0,0.5,0.0,0.5),
            child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(lesson: posts[index],)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${posts[index].tags}", style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500, fontSize: 16.0),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,12.0,0.0,12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(child: Text(posts[index].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),), flex: 3,),
                            Flexible(
                              flex: 1,
                              child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  child: Image.network('http://10.0.2.2:3000/image/${posts[index].image}',fit: BoxFit.cover)

                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(posts[index].author, style: TextStyle(fontSize: 18.0),),
                              Text(parseTime(posts[index].dateAdded) , style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),)
                            ],
                          ),
                          Icon(Icons.bookmark_border),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: posts.length,
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
          defaultSelectedIndex: 2,
        ),
      floatingActionButton: isAuthor ?FloatingActionButton(backgroundColor:Colors.black38 ,
        onPressed: () {
          _navigateToAddScreen(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ):null


    );
  }

  _navigateToAddScreen (BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPostWidget(userId: userId,username: username,)),
    );



  }



  //For decoding the JWT

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
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