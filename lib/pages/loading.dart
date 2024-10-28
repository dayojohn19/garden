import 'package:flutter/material.dart';
import 'package:app/services/place_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  late String place;
  void setupResortData() async {
    PlaceData instance =
        PlaceData(placeName: 'Resort placeName', placeURL: 'placeUrlTest');
    await instance.getPlace();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'placeName': instance.placeName,
      'placeURL': instance.placeURL
    });
  }

  @override
  void initState() {
    super.initState();
    setupResortData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 17, 148, 255),
        body: Center(
          child: SpinKitCubeGrid(
            color: Colors.white,
            size: 50.0,
          ),
        ));
  }
}