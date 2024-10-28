import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class Load_API extends StatefulWidget {
  const Load_API({super.key});

  @override
  State<Load_API> createState() => _Load_APIState();
}

class _Load_APIState extends State<Load_API> {
  late String apiURL;

  // void getThatAPI() async {
  //   GetAPI instance = GetAPI(apiURL: apiURL);
  //   await instance.apiResult();
  //   // ignore: use_build_context_synchronously
  //   Navigator.pushReplacementNamed(context, '/home',
  //       arguments: {'apiURL': instance.apiURL});
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getThatAPI();
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: SpinKitCubeGrid(
          color: Color.fromARGB(255, 121, 121, 121),
          size: 50,
        ),
      ),
    );
  }
}
