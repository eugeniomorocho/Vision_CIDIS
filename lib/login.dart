import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;


import 'pantallaprincipal.dart';


//Pantalla principal de Log In
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //Helper Method de pantalla principal de Login
  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  //Method para Login y Signup con POST Request.
  //Retorna el JWT si la autenticación es correcta.
  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
        "$SERVER_IP/login",
        body: {
          "username": username,
          "password": password
        }
    );
    //Retorna "null" en caso de error (i.e. wrong username/password).
    if(res.statusCode == 200) return res.body;
    return null;
  }

  //Method para SignUp, solo retorna el status (201 ok ó 409 error)
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

                    //Botón attempt LOG IN
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
                                    //builder: (context) => HomePage.fromBase64(jwt)
                                    builder: (context) => PantallaOpciones()
                                )
                            );
                          } else {
                            displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                          }
                        },
                        child: Text("Log In")
                    ),

                    //Botón attempt SIGN UP
                    FlatButton(
                      onPressed: () async {
                        var username = _usernameController.text;
                        var password = _passwordController.text;
                        //Revisa en frontend que el username y password tengan mas de 4 caracteres
                        if(username.length < 4)
                          displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                        else if(password.length < 4)
                          displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                        //Crea el usuario en backend o genera error
                        else{
                          var res = await attemptSignUp(username, password);
                          if(res == 201)
                            displayDialog(context, "Success", "The user was created. Log in now.");
                          else if(res == 409)
                            displayDialog(context, "That username is already registered", "Please try to sign up using another username, or log in if you already have an account.");
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