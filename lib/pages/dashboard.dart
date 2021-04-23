import 'dart:convert';
import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:final_food_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future getData(String endPoint) async {
    var response = await Api().getData(endPoint);
    var data = json.decode(response.body);
    return data;
  }

  Future getBooks(String endPoint) async {
    var response = await Api().getData(endPoint);
    var data = json.decode(response.body)['data'];
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of<ProductProvider>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'share');
          },
          child: Icon(Icons.share),
        ),
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("PADNE SATHI"),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, 'search');
                })
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 3)).then((onvalue) {});
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Categories"),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                          future: getData('categories'),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                                break;
                              default:
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    var mydata = snapshot.data[index];
                                    return GestureDetector(
                                      onTap: () {
                                        provider.setCategoryID(mydata['id']);
                                        Navigator.pushNamed(
                                            context, 'booklist');
                                      },
                                      child: Container(
                                        width: 100,
                                        child: Card(
                                          elevation: .2,
                                          child: Center(
                                            child: Text(
                                              mydata['name'],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                            }
                          },
                        ),
                      )),

                  //  LATEDST BOOK ADDED
                  ListTile(
                    title: Text("Lasted Shared Book"),
                  ),

                  FutureBuilder(
                    future: getBooks('books'),
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
                              return GestureDetector(
                                onTap: () {
                                  provider.setBookID(mydata['id']);
                                  Navigator.pushNamed(context, 'bookprofile');
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                      elevation: .2,
                                      child: ListTile(
                                        leading: Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                              link + mydata['image']),
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
                                                        mydata['price']
                                                            .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                            mydata['description'] == null
                                                ? SizedBox()
                                                : Text(
                                                    mydata['description'],
                                                    style:
                                                        TextStyle(fontSize: 12),
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

                  //  LATEDST REQUESTED BOOK
                  ListTile(
                    title: Text("Lasted Requested Book"),
                  ),

                  FutureBuilder(
                    future: getBooks('bookrequest'),
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
                              return GestureDetector(
                                onTap: () {
                                  provider.setBookID(mydata['id']);
                                  Navigator.pushNamed(context, 'bookprofile');
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                      elevation: .2,
                                      child: ListTile(
                                        leading: Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                              link + mydata['image']),
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
                                                        mydata['price']
                                                            .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                            mydata['description'] == null
                                                ? SizedBox()
                                                : Text(
                                                    mydata['description'],
                                                    style:
                                                        TextStyle(fontSize: 12),
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
        ));
  }
}
