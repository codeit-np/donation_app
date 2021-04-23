import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  Future getBooks(int id) async {
    var response = await Api().getData('categories/$id');
    var data = json.decode(response.body)['data'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text("Book List"),
              ),
              FutureBuilder(
                future: getBooks(provider.categoryID),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    default:
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var mydata = snapshot.data[index];
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: GestureDetector(
                              onTap: () {
                                provider.setBookID(mydata['id']);
                                Navigator.pushNamed(context, 'bookprofile');
                              },
                              child: Card(
                                  elevation: .2,
                                  child: ListTile(
                                    leading: Container(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Image.network(link + mydata['image']),
                                    ),
                                    title: Text(mydata['name']),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Publication: " +
                                              mydata['publication'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        mydata['price'] == null
                                            ? SizedBox()
                                            : Text(
                                                'Price: Rs.' +
                                                    mydata['price'].toString(),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                        mydata['description'] == null
                                            ? SizedBox()
                                            : Text(
                                                mydata['description'],
                                                style: TextStyle(fontSize: 12),
                                                maxLines: 2,
                                              ),
                                        Divider(),
                                        Text(
                                          mydata['status'] +
                                              " | " +
                                              mydata['created_at'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
