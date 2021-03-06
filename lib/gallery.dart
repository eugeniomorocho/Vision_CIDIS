import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:visioncidis/pantallaprincipal.dart';
import 'package:visioncidis/results.dart';
import 'main.dart';
import 'dart:convert';
import 'package:hive/hive.dart';

class UploadGallery extends StatefulWidget {
  UploadGallery({Key key, this.username, this.jwt, this.user_mail}) : super(key: key);
  final String url = '$SERVER_IP/upload';

  final String username;
  final String user_mail;
  final jwt;


  @override
  _UploadGalleryState createState() => _UploadGalleryState();
}


// class User {
//   final String username;
//   final String user_mail;
//
//   User(this.username, this.user_mail);
//
//   User.fromJson(Map<String, dynamic> json)
//       : username = json['name'],
//         user_mail = json['email'];
//
//   Map<String, dynamic> toJson() =>
//       {
//         'name': username,
//         'email': user_mail,
//       };
// }


class _UploadGalleryState extends State<UploadGallery> {

  void displayDialog(context, title, text) => showDialog(

    context: context,
    builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Upload Another"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadGallery(username: widget.username,)),
                );
              },
            ),
            new FlatButton(
              child: Text("Back to Main Menu"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaOpciones(widget.username,widget.jwt,widget.user_mail)),
                );
              },
            ),
          ],
        ),
  );


  //Status_code 200 ok / 201 Error
  Future<int> uploadImage(file, url, username) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    //****************************** Para enviar el username con la foto
    request.fields['username'] = username;
    //******************************
    request.files.add(await http.MultipartFile.fromPath('picture', file));
    var res = await request.send();
    final responseJson = json.decode(await res.stream.bytesToString());
    var request_number = responseJson['request'];
    //return res.reasonPhrase;
    return res.statusCode;
  }

  String state = "";

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image from Gallery'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: Text(
                "Vision CIDIS Gallery Upload",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              "To select an image from your gallery, please tap the button below.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),

            Text(state)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var fileFromGallery = await ImagePicker.pickImage(source: ImageSource.gallery);
          //*********************************************************
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
              });
          //*********************************************************
          var res = await uploadImage(fileFromGallery.path, widget.url, widget.username);
          Navigator.pop(context);

          if(res == 200){
            displayDialog(context, "Success", "The image has been uploaded");
            //Send image to results

          }
          else if(res == 201)
            displayDialog(context, "An Error Occurred", "Try uploading the image again");
          else {
            displayDialog(context, "Error", "An unknown error occurred.");
          }


          setState(() {
            state = res as String;
            print(res);
          });
        },
        child: Icon(Icons.photo_library),
      ),
    );
  }
}