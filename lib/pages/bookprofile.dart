import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:final_food_app/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookProfilePage extends StatefulWidget {
  @override
  _BookProfilePageState createState() => _BookProfilePageState();
}

class _BookProfilePageState extends State<BookProfilePage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future getData(int id) async {
    var response = await Api().getData("books/$id");
    var data = json.decode(response.body)['data'];
    print(data);
    book.text = data[0]['name'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getData(provider.bookID),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  default:
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Image.network(
                            link + snapshot.data[0]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        ListTile(
                          title: Text(snapshot.data[0]['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Publication: " +
                                    snapshot.data[0]['publication'],
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Category: " +
                                    snapshot.data[0]['category'].toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Status: " +
                                    snapshot.data[0]['status'].toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Provider: " +
                                    snapshot.data[0]['user'].toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Address: " +
                                    snapshot.data[0]['address'].toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              snapshot.data[0]['mobile'] == null
                                  ? Text(
                                      "Contact: N/A",
                                      style: TextStyle(fontSize: 12),
                                    )
                                  : Text(
                                      "Contact: " +
                                          snapshot.data[0]['mobile'].toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                              snapshot.data[0]['price'] == null
                                  ? SizedBox()
                                  : Text(
                                      "Price " +
                                          snapshot.data[0]['price'].toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Request Book"),
                                            content: Container(
                                              height: 200,
                                              child: Form(
                                                key: _key,
                                                child: Column(
                                                  children: [
                                                    inputText(
                                                        book,
                                                        'Book Name',
                                                        Icons.book,
                                                        false,
                                                        true,
                                                        TextInputType.text),
                                                    inputText(
                                                        remarks,
                                                        'Remarks',
                                                        Icons.message,
                                                        false,
                                                        true,
                                                        TextInputType.text),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          if (_key.currentState
                                                              .validate()) {
                                                            Map data = {
                                                              "name": book.text,
                                                              "remarks":
                                                                  remarks.text,
                                                              "category_id":
                                                                  snapshot.data[
                                                                          0][
                                                                      'category_id'],
                                                            };
                                                            var response =
                                                                await Api()
                                                                    .postData(
                                                                        data,
                                                                        'bookrequest');
                                                            var result = json
                                                                .decode(response
                                                                    .body);
                                                            if (result[
                                                                    'message'] ==
                                                                'success') {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          "Message"),
                                                                      content: Text(
                                                                          "Your request has been sent\nWe will call you shortly"),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text("OK"))
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          }
                                                        },
                                                        child: Text("Request"))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text("Request Book"))
                            ],
                          ),
                        )
                      ],
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
