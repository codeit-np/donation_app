import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/model/category.dart';
import 'package:final_food_app/provider/darkmode.dart';
import 'package:final_food_app/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future getData() async {
    var response = await Api().getData('user');
    var data = json.decode(response.body);
    return data;
  }

  List<Category> categories = [];
  String selectedCategory;
  int categoryID;

  void getCategories() async {
    var response = await Api().getData('categories');
    var data = json.decode(response.body);
    print(data);
    categories = [];
    for (var item in data) {
      Category category = new Category(
          id: item['id'].toString(), name: item['name'].toString());

      setState(() {
        categories.add(category);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    DarkMode darkMode = Provider.of<DarkMode>(context);
    return Drawer(
      child: ListView(
        children: [
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return UserAccountsDrawerHeader(
                    accountName: Text(snapshot.data['name']),
                    accountEmail: Text(snapshot.data['email']),
                    currentAccountPicture: CircleAvatar(
                      child: Text(
                        snapshot.data['name'].toString().substring(0, 1),
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  );
              }
            },
          ),
          ListTile(
            onTap: () => Navigator.pop(context),
            leading: Icon(Icons.dashboard),
            title: Text("Dashboard"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'profile');
            },
            leading: Icon(Icons.person),
            title: Text("Edit Profile"),
          ),

          ListTile(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: Text("Request a book"),
                      content: Container(
                        height: 250,
                        child: Form(
                            key: _key,
                            child: Column(
                              children: [
                                inputText(book, 'Book Name', Icons.book, false,
                                    true, TextInputType.text),
                                inputText(remarks, 'Remarks', Icons.message,
                                    false, true, TextInputType.text),
                                DropdownButtonFormField(
                                  value: selectedCategory,
                                  hint: Text('Select Category'),
                                  isExpanded: true,
                                  items: categories.map((value) {
                                    return DropdownMenuItem(
                                      value: value.id,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (_key.currentState.validate()) {
                                        print(selectedCategory);
                                        Map data = {
                                          "name": book.text,
                                          "remarks": remarks.text,
                                          "category_id": selectedCategory
                                        };
                                        var response = await Api()
                                            .postData(data, 'bookrequest');
                                        var result = json.decode(response.body);
                                        if (result['message'] == 'success') {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Message"),
                                                  content: Text(
                                                      "Your request has been sent\nWe will call you shortly"),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("OK"))
                                                  ],
                                                );
                                              });
                                        }
                                      }
                                    },
                                    child: Text("Request"))
                              ],
                            )),
                      ),
                    );
                  });
            },
            leading: Icon(Icons.person),
            title: Text("Request Book"),
          ),
          // ListTile(
          //   leading: Icon(Icons.pages),
          //   title: Text("Purchase History"),
          // ),
          ListTile(
            leading: Icon(Icons.brightness_2_outlined),
            title: Text("Enable Night Mode"),
            trailing: Switch(
              value: darkMode.flag,
              onChanged: (value) {
                darkMode.setFlag(value);
              },
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'feedback');
            },
            leading: Icon(Icons.feedback),
            title: Text("Feedback"),
          ),
          ListTile(
            onTap: () async {
              Map data = {};
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              Api().postData(data, 'logout').whenComplete(() {
                preferences.remove('token');
                Navigator.popAndPushNamed(context, 'login');
              });
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          )
        ],
      ),
    );
  }
}
