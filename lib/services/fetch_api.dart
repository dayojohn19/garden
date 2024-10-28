import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:http/http.dart';

import 'package:app/apis/api_key.dart';

import 'dart:io';

class FetchAPIservice {
  // Test Development
  String lookUpQRCode =
      "https://dayojohn19-django--8000.prod1a.defang.dev/garden/";
  // String lookUpQRCode = "http://192.168.101.4:8000/garden/";
  String subUrl;
  String? apiServiceUrl;
  Map argumentsToPass;
  dynamic serverResponseBody;

  dynamic collectionDescription;
  dynamic collectionName;
  dynamic placeVisitorLists;
  dynamic collectionPicture;
  dynamic collectionCollector;
  dynamic collectionUniqueID;
  dynamic collectionPlace;
  dynamic collectionIsCollected;
  dynamic collectionProvince;
  // Visitor
  dynamic visitorName;
  dynamic visitorCollections;
  dynamic visitorVisitedPlace;
  FetchAPIservice({required this.subUrl, required this.argumentsToPass});

  Future<Map?> collectionAPI() async {
    debugPrint('\n\n\n How Many SetupScan Result \n\n');

    debugPrint('FetchApiService Running');

    try {
      debugPrint('\nBuilding FetchAPIservice ${lookUpQRCode + subUrl} \n');
      Response response = await http.put(
        Uri.parse(lookUpQRCode + subUrl),
        headers: {
          // "Referer": "https://yoursite.com",
          HttpHeaders.authorizationHeader: 'Basic_token',
        },
        body: const JsonEncoder().convert(argumentsToPass),
      );
      dynamic serverResponseBody =
          jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(
          "\n\n JSON DECODED: ${serverResponseBody!['collectionPlace']}\n\n\n");
      try {
        collectionDescription = serverResponseBody!['collectionDescription'];
        collectionName = serverResponseBody!['collectionName'];
        placeVisitorLists = serverResponseBody!['placeVisitorLists'];
        collectionPicture = serverResponseBody!['collectionPicture'];
        collectionCollector = serverResponseBody!['collectionCollector'];
        collectionUniqueID = serverResponseBody!['collectionUniqueID'];
        collectionPlace = serverResponseBody!['collectionPlace'];
        collectionIsCollected = serverResponseBody!['collectionIsCollected'];
        collectionProvince = serverResponseBody!['collectionProvince'];
        debugPrint(
            '$collectionName but ${serverResponseBody!['collectionName']}');
        // debugPrint('${serverResponseBody.collectionName}');
      } catch (e) {
        debugPrint('Cant get Collect Values');
      }
      """""
      def lookPlace(request):  return in data
      serverResponseBody!['result_data']
      """;
      try {
        visitorName = serverResponseBody!['visitorName'];
        visitorCollections = serverResponseBody!['visitorCollections'];
        // visitorCollections = serverResponseBody!['visitorCollections'];
        visitorVisitedPlace = serverResponseBody!['visitorVisitedPlace'];
        debugPrint('$visitorName is the visitorName');
      } catch (e) {
        debugPrint('Cant Get Visitor Model');
      }
      debugPrint(
          'Successfull Built Getting Body Response ${serverResponseBody!['collectionName']}\n again ${serverResponseBody!['collectionPlace']}');
      // return serverResponseBody;
      return serverResponseBody;
    } catch (e) {
      debugPrint('\nCaught Error:\n\n $e \n\n');
      return {'error': 'Could not fetch'};
    }
  }

  // ignore: prefer_typing_uninitialized_variables
}
