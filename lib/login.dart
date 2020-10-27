import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visioncidis/forgotpassword.dart';
import 'package:visioncidis/signup.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'pantallaprincipal.dart';
import 'dart:convert';

var username;

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

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

  void displayDialogTutorial(context, title, text) => showDialog(
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

  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
        "$SERVER_IP/login",
        body: {
          "username": username,
          "password": password
        }
    );
    // Compara el status (200 ok, ó 401 error).
    // Retorna el JWT si la autenticación es correcta.
    // Retorna "null" en caso de error (i.e. wrong username/password).
    if(res.statusCode == 200){
      return res.body;
    }
    //return res.statusCode;
    //return null;
    return res.body;
  }

  Future<int> attemptLogInStatus(String username, String password) async {
    var res = await http.post(
        "$SERVER_IP/login",
        body: {
          "username": username,
          "password": password
        }
    );
    return res.statusCode;
  }

  bool isPasswordVisible = false;

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
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.365), //To move the textbox and buttons down
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
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              icon: Icon(
                              // Based on passwordVisible state choose the icon
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  isPasswordVisible
                                      ? isPasswordVisible = false
                                      : isPasswordVisible = true;
                                });
                        },
                      ),
                      ),
                    ),

                    //Botón attempt LOG IN
                    Container(
                      margin: const EdgeInsets.only(top: 30.0),
                      child: RaisedButton(
                          color: Colors. black,
                          textColor: Colors.white,
                          onPressed: () async {
                            var username = _usernameController.text;
                            var password = _passwordController.text;

                            final responseJson = json.decode(await attemptLogIn(username, password));
                            var jwt = responseJson['token'];
                            var user_mail = responseJson['mail'];
                            var status_code = responseJson['status_code'];

                            //var jwt = await attemptLogIn(username, password);
                            if(jwt != null) {
                              storage.write(key: "jwt", value: jwt);
                              storage.write(key: "mail", value: user_mail);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      //builder: (context) => HomePage.fromBase64(jwt)
                                      builder: (context) => PantallaOpciones(username, jwt, user_mail)
                                  )
                              );
                            }

                            //var res = await attemptLogInStatus(username, password);
                            if(status_code == 200) // 409 Error: User already created but not active
                              displayDialogTutorial(context, "How to use the App", "Before taking the picture, make sure all the samples are placed in the screen.");
                            else if(status_code == 201) // 409 Error: User already created but not active
                              displayDialog(context, "That username is already registered but not active", "Please check your e-mail to activate your account.");
                            else if(status_code == 202) // User already exist
                              displayDialog(context, "That username don't exist or the password is incorrect.", "Please try again, or log in if you already have an account.");
                            else {
                              displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                            }

                          },
                          child: Text("Log In")
                      ),
                    ),

                    //Botón attempt SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),

                        RawMaterialButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(5.0),

                          onPressed: () async {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                            );
                          }, //async


                          child: Text("Sign Up",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          constraints: BoxConstraints(),
                          padding: const EdgeInsets.only(top: 0.0),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPassword()),
                            );
                          }, //async


                          child: Text("Forgot your password? ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //*********************************************************************
                    // FlatButton(
                    //     onPressed: () {
                    //       //Do something when pressed the button
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => PantallaOpciones()),
                    //       );
                    //     },
                    //     child: Text("Next")
                    // ),
                    //*********************************************************************

                  ],
                ),
              ),
            )
        )
    );
  }
}

