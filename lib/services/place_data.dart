import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

import 'package:app/apis/api_key.dart';

class PlaceData {
  String placeName;
  String placeURL;
  bool? isVisited;

  PlaceData({required this.placeName, required this.placeURL});

  Future<void> getPlace() async {
    // Map<String, String> header = <String, String> {
    //   "Content-Type": "applicatino/json",
    //   "X-Access-Key": myapikey
    // };

    try {
      Map<String, String> header = <String, String>{
        "Content-Type": "application/json",
        "X-Access-Key": myapikey
      };
      debugPrint('\nFetching JSON OBJECT\n');

      Response response = await http.get(
        Uri.parse("https://api.jsonbin.io/v3/b/670d1993acd3cb34a896c20e"),
        headers: header,
      );
      // if (response.statusCode == 200) {
      debugPrint('RESPONSE : ${response.body.toString()}');
      Map data = jsonDecode(response.body);
      debugPrint('$data');
      // }
      placeName = 'Fetched Name';
      placeURL = '$data';
    } catch (e) {
      debugPrint('\n Caught Error: \n\n $e');
    }
  }
}
