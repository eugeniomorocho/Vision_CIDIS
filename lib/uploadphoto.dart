import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter File Upload Example',
// //       home: StartPage(),
// //     );
// //   }
// // }



// class UploadImage extends StatelessWidget {
//   void switchScreen(str, context) =>
//       Navigator.push(context, MaterialPageRoute(
//           builder: (context) => UploadPage(url: str)
//       ));
//   @override
//   Widget build(context) {
//     TextEditingController controller = TextEditingController();
//     return Scaffold(
//         appBar: AppBar(
//             title: Text('Vision CIDIS File Upload')
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: <Widget>[
//               Text("Insert the URL that will receive the Multipart POST request (including the starting http://)", style: Theme.of(context).textTheme.headline),
//               TextField(
//                 controller: controller,
//                 onSubmitted: (str) => switchScreen(str, context),
//               ),
//               FlatButton(
//                 child: Text("Take me to the upload screen"),
//                 //onPressed: () => switchScreen(controller.text, context),
//                 //onPressed: () => switchScreen('http://192.168.2.122:3000/upload', context),
//                 onPressed: () => switchScreen('$SERVER_IP/upload', context),
//               )
//             ],
//           ),
//         )
//     );
//   }
// }



class UploadPage extends StatefulWidget {
  //UploadPage({Key key, this.url}) : super(key: key);
  final String url = '$SERVER_IP/upload';
  @override
  _UploadPageState createState() => _UploadPageState();
}


class _UploadPageState extends State<UploadPage> {

  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }
  String state = "";

  void seleccionImagen() async {
  var file = await ImagePicker.pickImage(source: ImageSource.gallery);
  var res = await uploadImage(file.path, widget.url);
  setState(() {
  state = res;
  print(res);
  });
}



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

          seleccionImagen();
          // var file = await ImagePicker.pickImage(source: ImageSource.gallery);
          // var res = await uploadImage(file.path, widget.url);
          // setState(() {
          //   state = res;
          //   print(res);
          // });
        },
        child: Icon(Icons.add),
      ),
    );

  }
}