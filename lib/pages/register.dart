import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/widgets/inputText.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  // Full Name
                  inputText(name, 'Full Name', Icons.person_add, false, true,
                      TextInputType.text),
                  SizedBox(
                    height: 10,
                  ),
                  inputText(email, 'Email', Icons.email, false, true,
                      TextInputType.emailAddress),

                  SizedBox(
                    height: 10,
                  ),
                  // Address
                  inputText(address, 'Address', Icons.location_city, false,
                      true, TextInputType.streetAddress),
                  SizedBox(
                    height: 10,
                  ),
                  inputText(mobile, 'Mobile', Icons.call, false, true,
                      TextInputType.phone),
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
                                'name': name.text,
                                'email': email.text,
                                'password': password.text,
                                'address': address.text,
                                'mobile': mobile.text,
                              };

                              var response =
                                  await Api().loginRegister(data, 'register');
                              var result = json.decode(response.body);
                              print(result);

                              if (result['message'] == 'success') {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        title: Text("Message"),
                                        content: Text('Registration Success'),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, 'login');
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                          child: Text("REGISTER"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
