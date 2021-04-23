import 'dart:convert';

import 'package:final_food_app/const/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // Login And Register
  Future loginRegister(
    Map data,
    String endPoint,
  ) async {
    String url = baseUrl + endPoint;
    var response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data));

    return response;
  }

  // Data POST
  Future postData(Map data, String endPoint) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    print(token);
    String url = baseUrl + endPoint;
    var response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data));
    // print(response.statusCode);
    return response;
  }

  // Data GET
  Future getData(String endPoint) async {
    String url = baseUrl + endPoint;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    return response;
  }
}
