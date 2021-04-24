import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ListTile(
                  title: Text("Give your feedback"),
                ),
                TextFormField(
                  controller: feedback,
                  decoration: InputDecoration(
                      hintText: 'Feedback', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              Map data = {'feedback': feedback.text};

                              var response =
                                  await Api().postData(data, 'feedback');
                              var result = json.decode(response.body);

                              print(result);
                              if (result['message'] == 'success') {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        title: Text("Message"),
                                        content:
                                            Text("Than you for your feedback"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Ok"))
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                          child: Text("Send")),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
