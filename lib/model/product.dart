import 'package:flutter/material.dart';

class ProductModel {
  @required
  String id;
  @required
  String name;
  @required
  int sp;
  @required
  int qty;
  @required
  String image;
  int amount;
  ProductModel(
      {this.id, this.name, this.sp, this.qty, this.image, this.amount});
}
