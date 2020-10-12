# Vision CIDIS App

A `Flutter` application developed and mantained by the Computer Vision Group from CIDIS-Espol.

## Getting Started

This project contains all the necessary files to compile and run the Front End mobile app.

## Connecting to the Back End
The following commands enable the connection and data transfer to/from the `Node.js` server:

### Sending a Request
The following command sends a request from the app to the server:
```dart
var res = await http.post(
        '$SERVER_IP/signup',
        body: {
          "username": username,
          "password": password
        }
    );
```

### Getting Information
The following command retrieves information from the server:


### Sending an Image to the Server
The following command sends an image to the server:


## About
Centro de Investigación, Desarrollo, e Innovación (CIDIS).\
Escuela Superior Politécnica del Litoral, Guayaquil, Ecuador.\
2020 all rights reserved.\
