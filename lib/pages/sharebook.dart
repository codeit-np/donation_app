import 'dart:convert';
import 'dart:io';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/model/category.dart';
import 'package:final_food_app/widgets/inputText.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShareBookScreen extends StatefulWidget {
  @override
  _ShareBookScreenState createState() => _ShareBookScreenState();
}

class _ShareBookScreenState extends State<ShareBookScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<Category> categories = [];
  String selectedCategory;
  int categoryID;

  String selecteStatus;

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

  Future save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token;
    token = preferences.getString('token');
    print(token);

    final uri = Uri.parse(baseUrl + 'books');

    // create multipart request
    MultipartRequest request = http.MultipartRequest(
      "POST",
      uri,
    );

    print("categoryID is" + selectedCategory.toString());
    print("Status is" + selecteStatus.toString());

    request.headers['Accept'] = 'application/json';
    request.headers['Content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ' + token;
    request.fields['name'] = book.text;
    request.fields['publication'] = publication.text;
    // request.fields['price'] = price.text;
    request.fields['category_id'] = selectedCategory;
    request.fields['status'] = selecteStatus;

    var pic = await http.MultipartFile.fromPath("image", imageFile.path);
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
              content: Text("Shared successfully"),
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

  List<String> status = ['Sale', 'Donate', 'Rent'];
  @override
  void initState() {
    super.initState();
    getCategories();

    setState(() {
      selecteStatus = 'Donate';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share Book"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                inputText(book, 'Book Name', Icons.book, false, true,
                    TextInputType.text),
                inputText(publication, 'Publication', Icons.public, false, true,
                    TextInputType.text),
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
                DropdownButtonFormField<String>(
                  value: selecteStatus,
                  hint: Text('Select Status'),
                  isExpanded: true,
                  items: status.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selecteStatus = value;
                    });
                  },
                ),
                selecteStatus == 'Donate'
                    ? SizedBox()
                    : inputText(price, 'Price', Icons.money, false, true,
                        TextInputType.text),
                IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () {
                      pickImage();
                    }),
                imageFile == null
                    ? SizedBox()
                    : Container(
                        width: 200,
                        height: 200,
                        child: Image.file(imageFile),
                      ),
                ElevatedButton(
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        save();
                      }
                    },
                    child: Text("Share"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
