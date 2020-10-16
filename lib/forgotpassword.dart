import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visioncidis/login.dart';
import 'main.dart';
import 'package:http/http.dart' as http;


class ForgotPassword extends StatelessWidget {

  final TextEditingController _usernameController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  // Method para SignUp con POST Request.
  Future<int> attemptSignUp(String username) async {
    var res = await http.post(
        '$SERVER_IP/forgotpassword',
        body: {
          "username": username,
        }
    );
    // Solo retorna el status (201 ok, ó 409 error).
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
                padding: EdgeInsets.only(top: 275.0), //To move the textbox and buttons down
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                      child: Text(
                        "Forgot Your Password?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            ),
                      ),
                    ),
                    Text(
                        "Enter your username and we will send you a link to reset your password",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                             fontSize: 15,
                             color: Colors.black54,
                         ),
                        ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          labelText: 'Username'
                      ),
                    ),

                    //Botón attempt SIGN UP
                    Container(
                      margin: const EdgeInsets.only(top: 30.0),
                      child: RaisedButton(
                          color: Colors. black,
                          textColor: Colors.white,
                          onPressed: () async {

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => LoginPage()),
                            // );

                            var username = _usernameController.text;

                            //Revisa en frontend que el username y password tengan mas de 4 caracteres
                            if(username.length < 4)
                              displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                            //Crea el usuario en backend o genera error
                            else{
                              var res = await attemptSignUp(username);
                              if(res == 200)
                                displayDialog(context, "Success", "We have sent your password to your registered e-mail.");
                              else if(res == 201)
                                displayDialog(context, "That username is not registered", "Please try to sign up using another username.");
                              else {
                                displayDialog(context, "Error", "An unknown error occurred.");
                              }
                            }
                          },
                          child: Text("Recover Password")
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Return to ",
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
                              MaterialPageRoute(builder: (context) => LoginPage()),
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

                  ],
                ),
              ),
            )
        )
    );
  }
}