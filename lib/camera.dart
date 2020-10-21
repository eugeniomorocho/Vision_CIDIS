import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:visioncidis/pantallaprincipal.dart';
import "package:visioncidis/login.dart";


void displayDialog(context, title, text) => showDialog(
  context: context,
  builder: (context) =>
      AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Take Another"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadCamera()),
              );
            },
          ),
          new FlatButton(
            child: Text("Back to Main Menu"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PantallaOpciones()),
              );
            },
          ),
        ],
      ),
);

class UploadCamera extends StatefulWidget {
  //UploadPage({Key key, this.url}) : super(key: key);
  final String url = '$SERVER_IP/upload';
  @override
  _UploadCameraState createState() => _UploadCameraState();
}

class _UploadCameraState extends State<UploadCamera> {

  Future<int> uploadImage(filename, url, username) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    //request.fields['username'] = username;
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    //return res.reasonPhrase;
    return res.statusCode;
  }

  String state = "";

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photo from Camera'),
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
                "Vision CIDIS Camera Upload",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              "To take a photo with the camera, please tap the button below.",
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
          var file = await ImagePicker.pickImage(source: ImageSource.camera);
          var res = await uploadImage(file.path, widget.url, username);

          if(res == 200){
            displayDialog(context, "Success", "The photo has been uploaded");
          }
          else if(res == 201)
            displayDialog(context, "An Error Occurred", "Try uploading the photo again");
          else {
            displayDialog(context, "Error", "An unknown error occurred.");
          }

          setState(() {
            state = res as String;
            print(res);
          });
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}