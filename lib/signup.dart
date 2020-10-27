import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visioncidis/login.dart';
import 'main.dart';
import 'package:http/http.dart' as http;


class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullnameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<int> attemptSignUp(String fullname, String username, String email, String password) async {
    var res = await http.post(
        '$SERVER_IP/signup',
        body: {
          "fullname": fullname,
          "username": username,
          "user_mail": email,
          "password": password
        }
    );
    // Solo retorna el status (201 ok, ó 409 error).
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
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.345), //To move the textbox and buttons down
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _fullnameController,
                      decoration: InputDecoration(
                          labelText: 'Full Name'
                      ),
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          labelText: 'Username'
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'E-mail'
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

                    //Botón attempt SIGN UP
                    Container(
                      margin: const EdgeInsets.only(top: 30.0),
                      child: RaisedButton(
                          color: Colors. black,
                          textColor: Colors.white,
                          onPressed: () async {

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );

                            var fullname = _fullnameController.text;
                            var username = _usernameController.text;
                            var email = _emailController.text;
                            var password = _passwordController.text;

                            //Revisa en frontend que el username y password tengan mas de 4 caracteres
                            if(email.length < 4)
                              displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                            else if(password.length < 4)
                              displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                            //Crea el usuario en backend o genera error
                            else{
                              var res = await attemptSignUp(fullname, username, email, password);
                              if(res == 200) // New user created. Check mail.
                                displayDialog(context, "Success", "The user was created. Please check your e-mail to activate your account. In case the code is not in your inbox, check your spam.");
                              else if(res == 201) // Error: User already created but not active
                                displayDialog(context, "That username is already registered but not active", "Please check your e-mail to activate your account.");
                              else if(res == 202) // User already exist
                                displayDialog(context, "That username is already registered", "Please try to sign up using another username, or log in if you already have an account.");
                              else if(res == 205) // User already exist
                                displayDialog(context, "Prueba", "Paty");
                              else {
                                displayDialog(context, "Error", "An unknown error occurred.");
                              }
                              //print('$res');
                            }
                          },
                          child: Text("Sign Up")
                      ),
                    ),


                  ],
                ),
              ),
            )
        )
    );
  }
}