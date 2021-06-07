import 'dart:convert';
import 'package:http/http.dart';
import 'package:smart_study/Models/Post.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class PostApiService {
  final String apiUrl = "10.0.2.2:3000";
  final storage = new FlutterSecureStorage();



  Future<List<Post>> getPosts() async {
    Response res = await get(Uri.http(apiUrl,"/posts"));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Post> cases = body.map((dynamic item) => Post.fromJson(item)).toList();
      return cases;
    } else {
      throw "Failed to load posts list";
    }
  }

  Future<Post> getPostById(String id) async {
    final response = await get(Uri.http(apiUrl,"/post/$id"));

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load a case');
    }
  }

  Future<void> createPost(Post _post) async {
    Map<String,String> data = {
      'title': _post.title,
      'content': _post.content,
      'author': _post.author,
      'userID': _post.userID,
      'tags': _post.tags,
    };
    String value = await storage.read(key: "jwt");

    var request = MultipartRequest(
      'POST', Uri.http(apiUrl,"/post/add"),
    );

    String filename = basename(_post.imageContent.path);

    request.files.add(
      MultipartFile(
        'upload',
        _post.imageContent.readAsBytes().asStream(),
        _post.imageContent.lengthSync(),
        filename: filename,
        contentType: MediaType('image','jpeg'),
      ),
    );

    Map<String,String> headers={
      "Content-type": "multipart/form-data",
      'auth-token': value,
    };

    request.headers.addAll(headers);
    request.fields.addAll(data);

    print("request: "+request.toString());
    var res = await request.send();
    print("This is response:"+res.toString());



  }

  Future<void> updatePost(String id,Post _post) async {
    Map<String,String> data = {
      'title': _post.title,
      'content': _post.content,
      'author': _post.author,
      'userID': _post.userID,
      'tags': _post.tags,
    };
    String value = await storage.read(key: "jwt");

    var request = MultipartRequest(
      'PUT', Uri.http(apiUrl,"/post/edit/$id"),
    );

    String filename = basename(_post.imageContent.path);

    request.files.add(
      MultipartFile(
        'upload',
        _post.imageContent.readAsBytes().asStream(),
        _post.imageContent.lengthSync(),
        filename: filename,
        contentType: MediaType('image','jpeg'),
      ),
    );

    Map<String,String> headers={
      "Content-type": "multipart/form-data",
      'auth-token': value,
    };

    request.headers.addAll(headers);
    request.fields.addAll(data);

    print("request: "+request.toString());
    var res = await request.send();
    print("This is response:"+res.toString());



  }



  // Future<Post> updatePost(String id, Post _post) async {
  //   Map data = {
  //     'title': _post.title,
  //     'content': _post.content,
  //     'author': _post.author,
  //     'upload': _post.image,
  //     'userID': _post.userID,
  //   };
  //
  //
  //   String value = await storage.read(key: "jwt");
  //   final Response response = await put(
  //     Uri.http(apiUrl,"/post/edit/$id"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'auth-token': value,
  //     },
  //     body: jsonEncode(data),
  //   );
  //   if (response.statusCode == 200) {
  //     return Post.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to update a case');
  //   }
  // }

  Future<void> deleteCase(String id) async {
    String value = await storage.read(key: "jwt");
    Response res = await delete(Uri.http(apiUrl,"/post/delete/$id"),headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'auth-token': value,
    });

    print(res.body);
    // if (res.statusCode == 200) {
    //   print("Post deleted");
    // } else {
    //   throw "Failed to delete a case.";
    // }
  }

}
