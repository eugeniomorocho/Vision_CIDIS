import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import "package:visioncidis/login.dart";
import "login.dart";


void displayDialog(context, title, text) => showDialog(
  context: context,
  builder: (context) =>
      AlertDialog(
          title: Text(title),
          content: Text(text)
      ),
);


class UploadGallery extends StatefulWidget {
  //UploadPage({Key key, this.url}) : super(key: key);
  final String url = '$SERVER_IP/upload';
  @override
  _UploadGalleryState createState() => _UploadGalleryState();
}

class _UploadGalleryState extends State<UploadGallery> {

  //Status_code 200 ok / 201 Error
  Future<String> uploadImage(filename, url, username) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    //****************************** Para enviar el username con la foto
    //request.fields['username'] = username;
    //******************************
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.reasonPhrase;
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
          var file = await ImagePicker.pickImage(source: ImageSource.gallery);
          var response = await uploadImage(file.path, widget.url, username);

          if(response == 200){
            displayDialog(context, "Success", "The image has been uploaded");
          }
          else if(response == 201)
            displayDialog(context, "An Error Occurred", "Try uploading the image again");
          else {
            displayDialog(context, "Error", "An unknown error occurred.");
          }

          setState(() {
            state = response;
            print(response);
          });
        },
        child: Icon(Icons.photo_library),
      ),
    );
  }
}