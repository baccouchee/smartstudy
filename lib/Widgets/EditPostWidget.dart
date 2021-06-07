import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_study/Models/Post.dart';
import 'package:smart_study/services/PostApiService.dart';

class EditPost extends StatefulWidget {

  EditPost({this.username,this.userId,this.postToEdit});
  final String username;
  final String userId;
  final Post postToEdit;

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  File _image;
  final PostApiService api = PostApiService();
  final _addFormKey = GlobalKey<FormState>();
  Post oldPost;

  //TextControllers
  TextEditingController _titleController;
  TextEditingController _contentController ;

  @override
  void initState() {
    super.initState();
    oldPost = widget.postToEdit;
    _titleController = TextEditingController(text :widget.postToEdit.title);
    _contentController = TextEditingController(text :widget.postToEdit.content);

  }


  String dropdownValue = 'Finance';



  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
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
                                value: widget.postToEdit.tags,
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
                              ):Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image:  NetworkImage('http://10.0.2.2:3000/image/${widget.postToEdit.image}'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),),
                              RaisedButton(
                                onPressed: () async{
                                  if (_addFormKey.currentState.validate()) {
                                    _addFormKey.currentState.save();
                                    await api.updatePost(widget.postToEdit.id,Post.newPost(title: _titleController.text,content: _contentController.text,imageContent: _image,author: "${widget.username}" ,userID: widget.userId,tags: dropdownValue));

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
