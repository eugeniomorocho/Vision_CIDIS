import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

const SERVER_IP = 'http://192.168.1.247:3000';
final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // Widget root.
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");

              if(jwt.length !=3) {
                return LoginPage();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  return HomePage(str, payload);
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          }
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
        "$SERVER_IP/login",
        body: {
          "username": username,
          "password": password
        }
    );
    if(res.statusCode == 200) return res.body;
    return null;
  }

  Future<int> attemptSignUp(String username, String password) async {
    var res = await http.post(
        '$SERVER_IP/signup',
        body: {
          "username": username,
          "password": password
        }
    );
    return res.statusCode;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false, //Avoid widgets resize when keyboard appears
        //appBar: AppBar(title: Text("Vision CIDIS"),),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/MAIN.jpg"),
              fit: BoxFit.fill,
           ),
          ),
         child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.only(top: 250.0), //To move the textbox and buttons down
           child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    if(jwt != null) {
                      storage.write(key: "jwt", value: jwt);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage.fromBase64(jwt)
                          )
                      );
                    } else {
                      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                    }
                  },
                  child: Text("Log In")
              ),
              FlatButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    if(username.length < 4)
                      displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                    else if(password.length < 4)
                      displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                    else{
                      var res = await attemptSignUp(username, password);
                      if(res == 201)
                        displayDialog(context, "Success", "The user was created. Log in now.");
                      else if(res == 409)
                        displayDialog(context, "That username is already registered", "Please try to sign up using another username or log in if you already have an account.");
                      else {
                        displayDialog(context, "Error", "An unknown error occurred.");
                      }
                    }
                  },
                  child: Text("Sign Up"),
              ),

              FlatButton(
                onPressed: () {
                  //Do something when pressed the button
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PantallaOpciones()),
                  );
                },
                child: Text("Next")
              ),

            ],
          ),
          ),
        )
        )
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) =>
      HomePage(
          jwt,
          json.decode(
              ascii.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text("Secret Data Screen")),
        body: Center(
          child: FutureBuilder(
              future: http.read('$SERVER_IP/data', headers: {"Authorization": jwt}),
              builder: (context, snapshot) =>
              snapshot.hasData ?
              Column(children: <Widget>[
                Text("${payload['username']}, here's the data:"),
                Text(snapshot.data, style: Theme.of(context).textTheme.display1)
              ],)
                  :
              snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
          ),
        ),
      );
}


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
              Card(
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
                )
              ),
              Card(
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
              title: Text('Logout'),
             onTap: () {},
            ),
          ],
        ),
      ),


    );
  }
}















