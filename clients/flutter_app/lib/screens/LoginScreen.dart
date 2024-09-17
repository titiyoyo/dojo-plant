import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'FormScreen.dart';
import '../lib/ApiClient.dart';
import '../globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 300,
                  child: Image.asset('images/usf-logo-blue.png')
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com'
                ),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0
              ),
              child: TextField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password',
                ),
                onChanged: (value){
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  ApiClient client = ApiClient();
                  String body = jsonEncode({
                    'username': username,
                    'password': password
                  });
                  http.Response response = await client.post(
                    dotenv.env['LOGIN_PATH'],
                    body
                  );

                  var decodedResponse = jsonDecode(response.body);
                  const storage = FlutterSecureStorage();
                  await storage.write(key: 'token', value: decodedResponse['token']);
                  globals.setGlobals();

                  Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FormScreen(camera: globals.camera))
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
