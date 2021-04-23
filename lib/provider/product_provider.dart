import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  int _categoryID;
  int _bookID;

  void setCategoryID(int data) {
    _categoryID = data;
    notifyListeners();
  }

  int get categoryID {
    return _categoryID;
  }

  void setBookID(int data) {
    _bookID = data;
    notifyListeners();
  }

  int get bookID {
    return _bookID;
  }
}
