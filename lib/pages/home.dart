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
  var isShowMyCollection = false;
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
    setState(() {
      userAppUsername = usernameController.text;
      userAppUserID = userIDController.text;
      isShowMyCollection = true;
    });
    debugPrint('\nSaving Username $userAppUsername ID $userAppUserID');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'currentUserLoginDetails', [userAppUsername, userAppUserID]).then((_) {
      getAuthVisitor();
      showDialog(
        context: context,
        builder: (context) {
          return const SimpleDialog(
            children: [
              Center(
                child: Text('Details saved to Device !'),
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
        isShowMyCollection = true;
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
      setState(() {
        userAppUserID = '';
        userAppUsername = '';
        isShowMyCollection = false;
      });
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
                        child: isShowMyCollection
                            ? ElevatedButton.icon(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, '/collection', arguments: {
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
                                  'My Collection',
                                  style: TextStyle(color: Colors.amber[700]),
                                ),
                                icon: const Icon(
                                  Icons.collections_rounded,
                                  color: Colors.green,
                                ),
                              )
                            : const Text(' ')),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Welcome  \n $userAppUsername',
                      style: const TextStyle(
                          fontSize: 45,
                          letterSpacing: 2,
                          color: Color.fromARGB(255, 37, 19, 19)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Enjoy Collecting Cards !',
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
                                child: const Text('Log out'),
                                onPressed: () {
                                  clearDetailsFromDevice();
                                }),
                          ],
                        );
                      } else {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 250,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.orange,
                                        ),
                                        hintText: "Your Username",
                                        hintStyle:
                                            TextStyle(color: Colors.orange),
                                      ),
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
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.password,
                                          color: Colors.orange,
                                        ),
                                        hintText: "Your Pin",
                                        hintStyle:
                                            TextStyle(color: Colors.orange),
                                      ),
                                      controller: userIDController,
                                      textAlign: TextAlign.center,
                                      onChanged: (input) {
                                        // setState(() {
                                        //   userAppUserID = input;
                                        // });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              ElevatedButton(
                                  child: const Text('Start Collecting'),
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
