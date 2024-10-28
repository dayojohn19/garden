import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:camera/camera.dart';

import 'package:app/services/fetch_api.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

// --------------
class _QRScannerState extends State<QRScanner> {
  String username = '';
  String userID = '';
// TODO GO BACK TO Home page if no username and user iD or dont put button to scan code
  // Fetching form device
  // Future<void> fetchDetailsFromDevice() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final details = prefs.getStringList('currentUserLoginDetails');
  //   debugPrint('what details');
  //   if (details != null) {
  //     setState(() {
  //       debugPrint('$details');
  //       username = details[0];
  //       userID = details[1];
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // fetchDetailsFromDevice();
  // }

  // void lookUpQRCode(lookUpQRCodeValue) async {
  //   debugPrint('Creating FetchAPIservice Instance...');

  //   FetchAPIservice instance =
  //       FetchAPIservice(subUrl: 'look',lookUpQRCodeValue);
  //   await instance.apiResult();
  //   // debugPrint('${instance.apiServiceValue} ${instance.serverResponseBody} instance is printed \n\n\n');
  //   // ignore: use_build_context_synchronously
  //   Navigator.pushReplacementNamed(context, '/collectionscreen', arguments: {
  //     'serverResponseBody': 'instance.apiServiceUrl',
  //   });

  //   debugPrint(
  //       'Finished From scan code lookUpQRCode serverResponseBody \n $instance');
  //   debugPrint('${instance.serverResponseBody}');
  //   // apiDetails = instance;
  //   // Add push to Place Details
  //   // return const Text("apiDetails.serverResponseBody;");

  //   // Navigator.pushReplacementNamed(context, '/home', arguments: {
  //   //   'placeName': instance.placeName,
  //   //   'placeURL': instance.placeURL
  //   // });
  // }

  void pushApiDetails(apiDetails) {
    debugPrint('Add to collection');
  }

  final MobileScannerController cameraController = MobileScannerController(
      detectionTimeoutMs: 2000,
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: true,
      facing: CameraFacing.back);

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    dynamic data = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Scan QR CODE'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // const SizedBox(
          //   height: 30,
          //   // child: Text(data['username']),
          // ),
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              //
              // ON DETECT
              //
              onDetect: (capture) {
                // When Camera Detect an Qr Code
                cameraController.stop();

                final List<Barcode> barcodes = capture.barcodes;
                // final Uint8List? image = capture.image;
                final image = capture.image;
                for (final barcode in barcodes) {
                  debugPrint('Found a Captured QR ');
                  debugPrint('${barcode.rawValue}');
                }

                if (image != null) {
                  // debugPrint('going to lookUpQRCode');

                  // if (image != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Continue "),
                        content: Image(image: MemoryImage(image)),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Confirm ?'),
                            onPressed: () {
                              debugPrint('\n\n\n How Many onPressed() \n\n');

                              Navigator.pushNamed(context, '/scan_loading',
                                  arguments: {
                                    'scan_result': barcodes.first.rawValue,
                                    'username': data['username'],
                                    'userID': data['userID']
                                  });

                              // pushApiDetails(apiDetails);
                              // Navigator.pop(context);
                              // lookUpQRCode(barcodes.first.rawValue);
                              // FutureBuilder(
                              //     future: lookUpQRCode("http://192.168.101.6:8000/garden/",
                              //         barcodes.first.rawValue),
                              //     builder: (_, snapshot) {
                              //       if (snapshot.hasError)
                              //         return Text('Error = ${snapshot.error}');
                              //       if (snapshot.connectionState ==
                              //           ConnectionState.waiting) {
                              //         return const Text("Loading");
                              //       }
                              //       return snapshot.data;
                              //     });

                              // Navigator.of(context).pop('/');
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget buildDialog(BuildContext, context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             color: const Color.fromARGB(0, 238, 238, 238),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TextButton.icon(
//                     onPressed: () {
//                       lookUpQRCode("http://192.168.101.6:8000/garden/");
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: Text(
//                               barcodes.first.rawValue ?? "",
//                             ),
//                             content: Image(image: MemoryImage(image!)),
//                             actions: <Widget>[
//                               TextButton(
//                                 child: const Text('Confirm ?'),
//                                 onPressed: () {
//                                   lookUpQRCode("http://192.168.101.6:8000/garden/");
//                                   // Navigator.of(context).pop('/');
//                                 },
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     label: const Text('Capture the Moment'),
//                     icon: const Icon(Icons.camera_alt_outlined),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 20)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       });
// }
