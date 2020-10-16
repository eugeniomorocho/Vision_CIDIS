# Vision CIDIS App

A `Flutter` application developed and mantained by the Computer Vision Group from CIDIS-Espol.

## Getting Started

This project contains all the necessary files to compile and run the Front End mobile app.

## Connecting to the Back End
The following commands enable the connection and data transfer to/from the `Node.js` server:

### Sending a Request
The following command sends a `POST` request from the app to the server:

`Signup`
```dart
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
```

`Login`
```dart
  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
        "$SERVER_IP/login",
        body: {
          "username": username,
          "password": password
        }
    );
```

`Logout`
```dart
onTap: () async {
    Navigator.pop(context);
    await storage.deleteAll();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
}, 
```

`Forgot_password`
```dart
var res = await http.post(
    "$SERVER_IP/login",
    body: {
      "username": username
    }
```

`Show_results`
```dart
var res = await http.post(
    "$SERVER_IP/login",
    body: {
      "username": username
    }
```



### Getting Information
The following command retrieves information from the server:


### Sending an Image to the Server
The following command sends an image to the server:



## API Interface
The app connects to the Backend through the following routes:\

`/signup`, which accepts **POST** requests in urlencoded format, containing two self-explanatory text fields: a username field and a password field and either responds with status code 201 if it was able to create the user, or status code 409 if it wasn’t;\
`/login`, which accepts **POST** requests in urlencoded format and accepts a username field and a password field, and either responds with status code 200 and the JWT in the body of the response, or with status code 401 if there is no user with the given username and password;\
`/data`, which accepts **GET** requests, which must have a JWT attached to the Authorization request header, and which will either return the “secret data” only to authenticated users (with status code 200) or a response with status code 401, meaning the JWT is invalid or has expired.\




## Requirements
### Front End
Android Studio
Flutter Plugin
Dart Plugin
### Back End
Node.JS
#### Back End Libraries
`sqlite3` (Create and access the SQLite database)\
`Express` (Web framework)\
`jsonwebtoken` (Create JSON Web Tokens)\
`multer` (Middleware for handling multipart/form-data to upload images)\
```aidl
$ npm init
```
```aidl
$ npm install --save express jsonwebtoken sqlite3 multer
```



## Implementing the Back End with Node
Navigate to your <server>.js directory through the command window `cmd` and type:

```aidl
$ node <server>.js
```


## About
Centro de Investigación, Desarrollo, e Innovación (CIDIS).\
Escuela Superior Politécnica del Litoral, Guayaquil, Ecuador.\
2020 all rights reserved.