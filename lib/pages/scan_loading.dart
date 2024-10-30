import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app/services/fetch_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScanLoading extends StatefulWidget {
  const ScanLoading({super.key});

  @override
  State<ScanLoading> createState() => _ScanLoadingState();
}

dynamic collectionValues;

class _ScanLoadingState extends State<ScanLoading> {
  void setupScanResult() async {
    debugPrint('\n\n\n How Many SetupScan Result \n\n');
    dynamic data = ModalRoute.of(context)?.settings.arguments;

    debugPrint('Settingup Scan result');
    // final data = ModalRoute.of(context)!.settings.arguments;
    FetchAPIservice instance =
        FetchAPIservice(subUrl: 'look', argumentsToPass: data);
    // Building Collection Instance
    await instance.collectionAPI();
    // debugPrint('${instance.serverResponseBody}');

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/scan_result', arguments: {
      'collectionDescription': instance.collectionDescription,
      'collectionName': instance.collectionName,
      'placeVisitorLists': instance.placeVisitorLists,
      'collectionPicture': instance.collectionPicture,
      'collectionCollector': instance.collectionCollector,
      'collectionUniqueID': instance.collectionUniqueID,
      'collectionPlace': instance.collectionPlace,
      'collectionIsCollected': instance.collectionIsCollected,
      'collectionProvince': instance.collectionProvince,
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScanResult();

    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 17, 148, 255),
        body: Center(
          child: SpinKitWanderingCubes(
            color: Colors.white,
            size: 50.0,
          ),
        ));
  }
}
