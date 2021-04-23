import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool flag = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo.png',
                    width: 120,
                  ),
                  inputText(email, 'Email', Icons.email, false, true,
                      TextInputType.emailAddress),
                  SizedBox(
                    height: 10,
                  ),
                  inputText(password, 'Password', Icons.lock, true, true,
                      TextInputType.text),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              Map data = {
                                'email': email.text,
                                'password': password.text
                              };

                              var response =
                                  await Api().loginRegister(data, 'login');
                              var result = json.decode(response.body);

                              if (result['message'] == 'success') {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                //Store api token
                                preferences.setString('token', result['token']);
                                Navigator.popAndPushNamed(context, 'dashboard');
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        title: Text("Message"),
                                        content: Text("Unauthorized user"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                          child: Text("LOGIN"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, 'register'),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Are you new user ? ',
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: 'Register here',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
