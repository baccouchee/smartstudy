
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class Service{

  Future<int> submitSubscription({File file,String filename,String token})async{
    ///MultiPart request
    var request = MultipartRequest(
      'POST', Uri.parse("https://your api url with endpoint"),

    );
    Map<String,String> headers={
      "Authorization":"Bearer $token",
      "Content-type": "multipart/form-data"
    };


    request.files.add(
      MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "name":"test",
      "email":"test@gmail.com",
      "id":"12345"
    });
    print("request: "+request.toString());
    var res = await request.send();
    print("This is response:"+res.toString());
    return res.statusCode;
  }


}