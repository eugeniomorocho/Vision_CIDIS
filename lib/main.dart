import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

import 'login.dart';
import 'pantallaprincipal.dart';

const SERVER_IP = 'http://192.168.2.122:3000';
final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Revisa si hay algun JWT válido para mostrar el HomePage, caso contrario pide Login.
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
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
              }
              else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  //return HomePage(str, payload); //El original que retornaba el "e-mail" y "Secret Data"
                  return PantallaOpciones(); // Llama a PantallaOpciones si el token está vigente
                }
                else {
                  return LoginPage();
                }
              }
            }
            else {
              return LoginPage();
            }
          }
      ),
    );
  }
}

//**************************************************************************************

//Pantalla principal de Login
// class LoginPage extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   //Helper Method de pantalla principal de Login
//   void displayDialog(context, title, text) => showDialog(
//     context: context,
//     builder: (context) =>
//         AlertDialog(
//             title: Text(title),
//             content: Text(text)
//         ),
//   );
//
//   //Method para Login y Signup con POST Request.
//   //Retorna el JWT si la autenticación es correcta.
//   Future<String> attemptLogIn(String username, String password) async {
//     var res = await http.post(
//         "$SERVER_IP/login",
//         body: {
//           "username": username,
//           "password": password
//         }
//     );
//     //Retorna "null" en caso de error (i.e. wrong username/password).
//     if(res.statusCode == 200) return res.body;
//     return null;
//   }
//
//   //Method para SignUp, solo retorna el status (201 ok ó 409 error)
//   Future<int> attemptSignUp(String username, String password) async {
//     var res = await http.post(
//         '$SERVER_IP/signup',
//         body: {
//           "username": username,
//           "password": password
//         }
//     );
//     return res.statusCode;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomPadding: false, //Avoid widgets resize when keyboard appears
//         //appBar: AppBar(title: Text("Vision CIDIS"),),
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/MAIN.jpg"),
//               fit: BoxFit.fill,
//            ),
//           ),
//          child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Padding(
//             padding: EdgeInsets.only(top: 250.0), //To move the textbox and buttons down
//            child: Column(
//             children: <Widget>[
//               TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                     labelText: 'Username'
//                 ),
//               ),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                     labelText: 'Password'
//                 ),
//               ),
//
//               //Botón attempt LOG IN
//               FlatButton(
//                   onPressed: () async {
//                     var username = _usernameController.text;
//                     var password = _passwordController.text;
//
//                     var jwt = await attemptLogIn(username, password);
//                     if(jwt != null) {
//                       storage.write(key: "jwt", value: jwt);
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => HomePage.fromBase64(jwt)
//                           )
//                       );
//                     } else {
//                       displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
//                     }
//                   },
//                   child: Text("Log In")
//               ),
//
//               //Botón attempt SIGN UP
//               FlatButton(
//                   onPressed: () async {
//                     var username = _usernameController.text;
//                     var password = _passwordController.text;
//                     //Revisa en frontend que el username y password tengan mas de 4 caracteres
//                     if(username.length < 4)
//                       displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
//                     else if(password.length < 4)
//                       displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
//                     //Crea el usuario en backend o genera error
//                     else{
//                       var res = await attemptSignUp(username, password);
//                       if(res == 201)
//                         displayDialog(context, "Success", "The user was created. Log in now.");
//                       else if(res == 409)
//                         displayDialog(context, "That username is already registered", "Please try to sign up using another username, or log in if you already have an account.");
//                       else {
//                         displayDialog(context, "Error", "An unknown error occurred.");
//                       }
//                     }
//                   },
//                   child: Text("Sign Up"),
//               ),
//
//               FlatButton(
//                 onPressed: () {
//                   //Do something when pressed the button
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => PantallaOpciones()),
//                   );
//                 },
//                 child: Text("Next")
//               ),
//
//             ],
//           ),
//           ),
//         )
//         )
//     );
//   }
// }

//**************************************************************************************

// HomePage
// class HomePage extends StatelessWidget {
//   HomePage(this.jwt, this.payload);
//
//   factory HomePage.fromBase64(String jwt) =>
//       HomePage(
//           jwt,
//           json.decode(
//               ascii.decode(
//                   base64.decode(base64.normalize(jwt.split(".")[1]))
//               )
//           )
//       );
//
//   final String jwt;
//   final Map<String, dynamic> payload;
//
// // The HomePage´s build() method
//   @override
//   Widget build(BuildContext context) =>
//       Scaffold(
//         appBar: AppBar(title: Text("Secret Data Screen")),
//         body: Center(
//           child: FutureBuilder(
//               future: http.read('$SERVER_IP/data', headers: {"Authorization": jwt}),
//               builder: (context, snapshot) =>
//               snapshot.hasData ?
//               Column(children: <Widget>[
//                 Text("${payload['username']}, here's the data:"),
//                 Text(snapshot.data, style: Theme.of(context).textTheme.display1)
//               ],
//               )
//               :
//               snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
//           ),
//         ),
//       );
//
// }

//**************************************************************************************

















