import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_study/Models/Post.dart';
import 'package:smart_study/services/PostApiService.dart';


class AddPostWidget extends StatefulWidget {
  //Constructor
  AddPostWidget({this.username,this.userId});
  final String username;
  final String userId;
  // File from the gallery or camera

  @override
  _AddPostWidgetState createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  _AddPostWidgetState();
  File _image;
  final PostApiService api = PostApiService();
  final _addFormKey = GlobalKey<FormState>();

  //TextControllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String dropdownValue = 'Finance';

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Create New Post"),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.green[300],
        onPressed: () {
          _imgFromGallery();
        },
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: 440,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Title'),
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter full name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Content'),
                              TextFormField(

                                controller: _contentController,
                                decoration: const InputDecoration(
                                  //contentPadding:  EdgeInsets.symmetric(vertical: 200.0, horizontal: 10.0),
                                  hintText: 'Content',
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Fill the Content Area';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Category'),
                              DropdownButton<String>(
                                isExpanded:true,
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
                                items: <String>['Business', 'Finance', 'Sports', 'Food','Programming','Security','Business plan']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Container(child: _image != null? Image.file(
                                _image,
                                width: 300,
                                height: 300,
                                fit: BoxFit.fitHeight,
                              ):Container()),
                              RaisedButton(
                                onPressed: () async{
                                  if (_addFormKey.currentState.validate()) {
                                    _addFormKey.currentState.save();
                                    await api.createPost(Post.newPost(title: _titleController.text,content: _contentController.text,imageContent: _image,author: "${widget.username}" ,userID: widget.userId,tags: dropdownValue));

                                    Navigator.pushReplacementNamed(context,"/home") ;
                                  }
                                },
                                child: Text('Save', style: TextStyle(color: Colors.white)),
                                color: Colors.green[300],
                              )
                            ],
                          ),
                        ),

                      ],
                    )
                )
            ),
          ),
        ),
      ),
    );
  }
}
