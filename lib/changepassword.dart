import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:visioncidis/forgotpassword.dart';
import 'package:visioncidis/login.dart';
//import 'package:visioncidis/signup.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'pantallaprincipal.dart';

var username,password,newpassword;

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({ this.username, this.user_mail, this.jwt});
  final String username,user_mail;
  //final Map<String, dynamic> payload;

  final  jwt;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _newconfirmpasswordController = TextEditingController();


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
                    //Navigator.pop(context);//
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          //builder: (context) => HomePage.fromBase64(jwt)
                            builder: (context) => LoginPage()
                        )
                    );
                  },
                ),
              ],
            )
        ),
  );

  // Method para Login con POST Request.
  Future<int> attemptChangepassword(String username, String password, String newpassword,String jwt) async {
    var res = await http.post(
        "$SERVER_IP/changepassword",
        body: {
          "username": username,
          "password": password,
          "newpassword": newpassword,
          "jwt": jwt
        }
    );
    // Compara el status (200 ok, ó 201 error).

    return res.statusCode;
    //return null;
  }

  //Future<int> attemptLogInStatus(String username, String password) async {
  //  var res = await http.post(
  //      "$SERVER_IP/login",
  //      body: {
  //        "username": username,
  //        "password": password
  //      }
  //  );
  //  return res.statusCode;
  //}


  @override
  Widget build(BuildContext context) { _usernameController.text = username;

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
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Current Password'
                    ),
                  ),
                  TextField(
                    controller: _newpasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'New Password'
                    ),
                  ),
                  TextField(
                    controller: _newconfirmpasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Confirm New Password'
                    ),
                  ),

                  //Botón attempt LOG IN
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      color: Colors. black,
                      textColor: Colors.white,
                      onPressed: () async {
                        var username = _usernameController.text;
                        var password = _passwordController.text;
                        var newpassword = _newpasswordController.text;
                        //var username = _usernameController.text;
                        var newpasswordconfirm = _newconfirmpasswordController.text;
                        if (username.length < 4)
                          displayDialog(context, "Invalid Username",
                              "The username should be at least 4 characters long");
                        else
                        if (password.length < 4 || newpassword.length < 4 ||
                            newpasswordconfirm.length < 4)
                          displayDialog(context, "Invalid New Password",
                              "The password should be at least 4 characters long");
                        else if (newpassword != newpasswordconfirm)
                          displayDialog(context, "Invalid Confirmation Password",
                              "The password should be at least 4 characters long");
                        else  if (newpassword == password) displayDialog(context, "Current and New password can not be equal",
                            "Please enter a different password");
                        else {
                          var res = await attemptChangepassword(
                              username, password, newpassword, jwt);

                          if (res == 200) {
                            displayDialogTutorial(context, "Success",
                                "The password has been update successfully. Please log in with the new credentials");
                            if (jwt != null) {
                              var jwt = await storage.read(key: "jwt");
                              if(jwt == null) return "";
                              storage.deleteAll();}

                          }
                          else {
                            if (res == 201) {
                              displayDialog(context, "Error",
                                  "The password could not be changed, check your current credentials and try again");
                            }
                          }
                        }
                      },
                      child: Text("Change Password"),

                    ),

                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(top:0.1,left:15),
                  //   child: RaisedButton(
                  //       color: Colors. black,
                  //       textColor: Colors.white,
                  //       onPressed: () async {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => PantallaOpciones(username,jwt,user_mail)));
                  //
                  //       },
                  //       child: Text("Cancel")
                  //   ),
                  // ),

                ],
              ),
            ),
          )
      )
  );
  }
}

