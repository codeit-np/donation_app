import 'dart:convert';
import 'dart:io';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String userID;
  Future getData() async {
    var response = await Api().getData('user');
    var data = json.decode(response.body);
    name.text = data['name'];
    address.text = data['address'];
    mobile.text = data['mobile'];
    userID = data['id'].toString();
    return data;
  }

  //For Image
  File imageFile;
  void pickImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile.path);
      print(imageFile);
    });
  }

  Future save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token;
    token = preferences.getString('token');
    print(token);

    final uri = Uri.parse(baseUrl + 'updateprofile/$userID');

    // create multipart request
    MultipartRequest request = http.MultipartRequest(
      "POST",
      uri,
    );
    request.headers['Accept'] = 'application/json';
    request.headers['Content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ' + token;
    request.fields['name'] = name.text;
    request.fields['mobile'] = mobile.text;
    request.fields['address'] = address.text;

    var pic = await http.MultipartFile.fromPath("photo", imageFile.path);
    request.files.add(pic);
    // request.fields['attachment'] = imageFile.path.split("/").last;
    var response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
              title: Text("Message"),
              content: Text("Update successful"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      snapshot.data['photo'] == null
                          ? Container(
                              width: 100,
                              height: 100,
                              child: Center(
                                child: Text("No Image"),
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                link + snapshot.data['photo'],
                                fit: BoxFit.cover,
                              ),
                            ),
                      ListTile(
                        title: Text("Update your profile"),
                      ),
                      inputText(name, "Full Name", Icons.person_add_alt, false,
                          true, TextInputType.text),
                      SizedBox(
                        height: 10,
                      ),
                      inputText(address, "Address", Icons.location_city, false,
                          true, TextInputType.streetAddress),
                      SizedBox(
                        height: 10,
                      ),
                      inputText(mobile, "Mobile", Icons.call, false, true,
                          TextInputType.phone),
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            pickImage();
                          }),
                      imageFile == null
                          ? SizedBox()
                          : Container(
                              child: Image.file(imageFile),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                                  icon: Icon(Icons.update),
                                  onPressed: () async {
                                    if (_key.currentState.validate()) {
                                      save();
                                    }
                                  },
                                  label: Text("Update"))),
                        ],
                      )
                    ],
                  ),
                ),
              );
          }
        },
      )),
    );
  }
}
