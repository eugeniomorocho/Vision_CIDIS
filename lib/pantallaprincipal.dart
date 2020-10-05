import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visioncidis/main.dart';
import 'camera.dart';
import 'gallery.dart';


class PantallaOpciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    MaterialPageRoute(builder: (context) => ScreenCamera()),
                  );
                },
                child: Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'DETECT',
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
                    MaterialPageRoute(builder: (context) => ScreenGallery()),
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
              Card(
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
                backgroundImage: AssetImage("assets/unnamed.jpg"),
              ),
              accountName: Text("Eugenio Morocho Cayamcela"),
              accountEmail: Text("maneumor@espol.edu.ec"),
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
            ),
            // ListTile(
            //   title: Text('Item 1'),
            //   onTap: () {},
            // ),

            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('Sign out'),
              onTap: () async {
                //Logout
                Navigator.pop(context); //Cierra el drawer

                await storage.deleteAll();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );


              }, //async
            ),
          ],
        ),
      ),


    );
  }
}