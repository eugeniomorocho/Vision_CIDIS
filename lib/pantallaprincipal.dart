import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visioncidis/main.dart';
import 'camera.dart';
import 'gallery.dart';
import 'login.dart';
import 'results.dart';


class PantallaOpciones extends StatelessWidget {
  PantallaOpciones(this.username);
  //PantallaOpciones(String username);

  //HomePage(this.jwt, this.payload);
  final String username;
  //final Map<String, dynamic> payload;

  //final String jwt;
  //final Map<String, dynamic> payload;


  void howToUseTheApp(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/tuto.jpg"),
                Text(text),
                FlatButton(
                  child: new Text(
                    "Agree",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
        ),
  );


  @override
  Widget build(BuildContext context) {
    //String username;
    var user1 = username;
    //final usuario={payload['username']};
    return new WillPopScope( // Deactivate "back" button
        onWillPop: () async => false,


        child: new Scaffold(
          resizeToAvoidBottomPadding: false, //Avoid widgets resize when keyboard appears
          appBar: AppBar(
            title: Text("Vision CIDIS"),
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
          body: Container(
            alignment: Alignment.center, //Centra las cards verticalmente
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/TEMPLATE.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: GridView.count(
                shrinkWrap: true, //Centra las cards verticalmente
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: <Widget>[
                  InkWell( //GestureDetector
                    onTap: () {
                      //Do something when pressed the button
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadCamera(username:username)),
                      );
                    },
                    child: Card(
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'CAMERA',
                              style: TextStyle(fontSize: 14.0),
                            ),
                            Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 75.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Do something when pressed the button
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadGallery(username: username)),
                      );
                    },
                    child: Card(
                        color: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: Column(
                              children: <Widget>[
                                Text(
                                  'GALLERY',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Icon(
                                  Icons.photo_library,
                                  color: Colors.black,
                                  size: 75.0,
                                ),
                              ]
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Do something when pressed the button
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultsPage()),
                      );
                    },
                    child: Card(
                        color: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: Column(
                              children: <Widget>[
                                Text(
                                  'RESULTS',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Icon(
                                  Icons.assignment,
                                  color: Colors.black,
                                  size: 75.0,
                                ),
                              ]
                          ),
                        )
                    ),
                  ),
                  Card(
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Column(
                            children: <Widget>[
                              Text(
                                'SETTINGS',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Icon(
                                Icons.settings,
                                color: Colors.black,
                                size: 75.0,
                              ),
                            ]
                        ),
                      )
                  ),
                ]
            ),
          ),

          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage("assets/user.png"),
                  ),
                  accountName: Text("username"),
                  accountEmail: Text("usernamer@domain.com"),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                  ),
                ),
                // ListTile(
                //   title: Text('Item 1'),
                //   onTap: () {},
                // ),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('How to use the App'),
                  onTap: () async {
                      howToUseTheApp(context, "How to use the App", "Before taking the picture, make sure all the samples are placed in the screen.");
                  }, //async
                ),

                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text('Sign out'),
                  onTap: () async {
                    //Logout
                    Navigator.pop(context); //Cierra el drawer

                    await storage.deleteAll();

                    // if (jwt != null) {
                    // var jwt = await storage.read(key: "jwt");
                    // if(jwt == null) return "";
                    // storage.deleteAll();
                    // };

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }, //async
                ),

              ],
            ),
          ),


        )
    );
  }
}