import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class UploadCamera extends StatefulWidget {
  //UploadPage({Key key, this.url}) : super(key: key);
  final String url = '$SERVER_IP/upload';
  @override
  _UploadCameraState createState() => _UploadCameraState();
}

class _UploadCameraState extends State<UploadCamera> {

  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.reasonPhrase;
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
          var res = await uploadImage(file.path, widget.url);
          setState(() {
            state = res;
            print(res);
          });
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}