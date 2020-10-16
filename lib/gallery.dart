import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class UploadGallery extends StatefulWidget {
  //UploadPage({Key key, this.url}) : super(key: key);
  final String url = '$SERVER_IP/upload';
  @override
  _UploadGalleryState createState() => _UploadGalleryState();
}

class _UploadGalleryState extends State<UploadGallery> {

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
        title: Text('Upload Image from Gallery'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(state)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var file = await ImagePicker.pickImage(source: ImageSource.gallery);
          var res = await uploadImage(file.path, widget.url);
          setState(() {
            state = res;
            print(res);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}