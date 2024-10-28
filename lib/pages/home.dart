import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:app/services/fetch_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
// ----------------

class _HomeState extends State<Home> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );
  Map data = {};
  String userAppUsername = '';
  String userAppUserID = '';
  Future? isVerified;
  // ignore: prefer_typing_uninitialized_variables
  // late var isVerified;
  @override
  initState() {
    fetchDetailsFromDevice();
    // _userCredentialData = fetchDetailsFromDevice();
  }

  // TRY TO GET DATA Visitor
  Future<Object> getAuthVisitor() async {
    try {
      debugPrint('Logging In Visitor...$userAppUsername and $userAppUserID');
      // Response response = await http.put(
      //   (Uri.parse(
      //       'https://dayojohn19-django--8000.prod1a.defang.dev/garden/visitor')),
      //   body: jsonEncode(<String, String>{
      //     'username': userAppUsername,
      //     'userID': userAppUserID
      //   }),
      // );
      FetchAPIservice instance = FetchAPIservice(
          subUrl: 'visitor',
          argumentsToPass: {
            'username': userAppUsername,
            'userID': userAppUserID
          });
      await instance.collectionAPI();
      // data = jsonDecode(response.body);
      // data = instance;
      debugPrint('We got from the server ${instance.visitorName}');
      // isVerified = true as Future;
      return instance;
    } catch (e) {
      debugPrint('Failed to Connect on the server ${e.toString()}');
      return false;
    }
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController userIDController = TextEditingController();

// clearing data
  Future<void> saveDetailsFromDevice() async {
    debugPrint('\nSaving Username $userAppUsername ID $userAppUserID');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'currentUserLoginDetails', [userAppUsername, userAppUserID]).then((_) {
      setState(() {
        userAppUsername = userAppUsername;
        userAppUserID = userAppUserID;
      });
      getAuthVisitor();
      showDialog(
        context: context,
        builder: (context) {
          return const SimpleDialog(
            children: [
              Center(
                child: Text('Details Saved from device'),
              ),
            ],
          );
        },
      );
    });
  }

  // Fetching form device
  Future<String> fetchDetailsFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserDetails = prefs.getStringList('currentUserLoginDetails');
    debugPrint('what details');
    if (currentUserDetails != null) {
      debugPrint('After Fetching Data....');

      setState(() {
        debugPrint('$currentUserDetails');
        userAppUsername = currentUserDetails[0];
        userAppUserID = currentUserDetails[1];

        usernameController.text = currentUserDetails[0];
        userIDController.text = currentUserDetails[1];
        // return  currentUserDetails as Map<String,dynamic>;
      });
      // getAuthVisitor();
    }
    return 'a';
  }

  // clearing data
  Future<void> clearDetailsFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((_) {
      showDialog(
        context: context,
        builder: (context) {
          return const SimpleDialog(
            children: [
              Center(
                child: Text('Details Cleared from device'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/backgroundImage.png'),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 130,
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/collection',
                              arguments: {
                                'username': userAppUsername,
                                'userID': userAppUserID
                              });
                          setState(() {
                            // data = {
                            //   'userAppUserName': userAppUserName,
                            //   'placeURL': result['placeURL']
                            // };
                          });
                        },
                        label: Text(
                          'My Collections',
                          style: TextStyle(color: Colors.amber[700]),
                        ),
                        icon: const Icon(Icons.collections_rounded),
                      ),
                    ),
                    Text(
                      'Welcome  \n $userAppUsername',
                      style: const TextStyle(
                          fontSize: 28,
                          letterSpacing: 2,
                          color: Color.fromARGB(255, 37, 19, 19)),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Enjoy Cards Collecting !',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: _calculation,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    debugPrint('Creating Future Builder\n');
                    if (snapshot.hasData) {
                      debugPrint(
                          'Snapshot has Data Here is the : ${snapshot.data}');
                      if (userAppUserID != '') {
                        return Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/scan', arguments: {
                                'username': userAppUsername,
                                'userID': userAppUserID
                              }),
                              label: const Text('Scan QR CODE'),
                              icon: const Icon(Icons.qr_code),
                              style: ElevatedButton.styleFrom(
                                //  fixedSize: 2,
                                // padding: const EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                                side: const BorderSide(
                                    width: 1, color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                  20,
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                child: const Text('Delete details to device'),
                                onPressed: () {
                                  clearDetailsFromDevice();
                                }),
                          ],
                        );
                      } else {
                        return Center(
                          child: Column(
                            children: [
                              const Text('Your Username :  '),
                              TextFormField(
                                controller: usernameController,
                                textAlign: TextAlign.center,
                                onChanged: (input) {
                                  setState(() {
                                    userAppUsername = input;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Pin: '),
                              TextFormField(
                                controller: userIDController,
                                textAlign: TextAlign.center,
                                onChanged: (input) {
                                  // setState(() {
                                  //   userAppUserID = input;
                                  // });
                                },
                              ),
                              ElevatedButton(
                                  child: const Text('Log In'),
                                  onPressed: () {
                                    setState(() {
                                      debugPrint(
                                          'Setting State ${userIDController.text} -- $userAppUserID');
                                      userAppUserID = userIDController.text;
                                      debugPrint(
                                          'Setting State ${userIDController.text} -- $userAppUserID');
                                    });
                                    saveDetailsFromDevice();
                                  }),
                              // ElevatedButton(
                              //     child: const Text('Fetch details to device'),
                              //     onPressed: () {
                              //       fetchDetailsFromDevice();
                              //     }),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
