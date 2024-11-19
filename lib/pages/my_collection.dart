import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/services/place_data.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:app/services/fetch_api.dart';
import 'dart:developer';

class MyCollection extends StatefulWidget {
  const MyCollection({super.key});

  @override
  State<MyCollection> createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  late Future<dynamic> myCollectionData;
  @override
  void initState() {
    super.initState;
    myCollectionData = fetchCollection();
  }

  Future fetchCollection() async {
    await Future.delayed(const Duration(seconds: 1));
    dynamic data = ModalRoute.of(context)?.settings.arguments;
    FetchAPIservice instance =
        FetchAPIservice(subUrl: 'visitor', argumentsToPass: data);
    await instance.collectionAPI();
    return instance;
  }

  void viewPlace(thePlace) async {
    PlaceData instance = thePlace;
    await instance.getPlace();
    debugPrint('Finished getting place ');
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'placeName': instance.placeName,
      'placeURL': instance.placeURL
    });
  }

  // Widget _CollectionListsBuilder(BuildContext context,collectionList) {

  // return  ListView.builder(
  //       itemBuilder: (context, collectionList) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
  //           child: Card(
  //             child: ListTile(
  //               onTap: () {
  //                 // debugPrint(locations[index].location);
  //                 // updateTime(index);
  //               },
  //               title: ',
  //               leading :CircleAvatar(
  //                 backgroundImage:
  //                     AssetImage('${collectionList.collectionPicture}'),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ))
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: RichText(text:const TextSpan(text: 'My Collection',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35,color: Colors.black))),
        centerTitle: true,
        elevation: 0,
        
      ),
      body: Container(
        child: FutureBuilder(
          future: myCollectionData,
          builder: (context, snapshot) {
            // var visitorObject;
            // var visitorCollectionList;
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text('Erro: $error');
            } else if (snapshot.hasData) {
              final visitorObject = snapshot.data;
              final visitorCollectionList = visitorObject.visitorCollections;
              return ListView.builder(
                itemCount: visitorCollectionList.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator
                              .pushNamed(context, '/scan_result', arguments: {
                            'collectionDescription':
                                visitorCollectionList[index]
                                    ['collectionDescription'],
                            'collectionName': visitorCollectionList[index]
                                ['collectionName'],
                            'placeVisitorLists': visitorCollectionList[index]
                                ['placeVisitorLists'],
                            'collectionPicture': visitorCollectionList[index]
                                ['collectionPicture'],
                            'collectionCollector': visitorCollectionList[index]
                                ['collectionCollector'],
                            'collectionUniqueID': visitorCollectionList[index]
                                ['collectionUniqueID'],
                            'collectionPlace': visitorCollectionList[index]
                                ['collectionPlace'],
                            'collectionIsCollected':
                                visitorCollectionList[index]
                                    ['collectionIsCollected'],
                            'collectionProvince': visitorCollectionList[index]
                                ['collectionProvince'],
                          });
                        },
                        title: Text(
                            visitorCollectionList[index]['collectionName']),
                        subtitle: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(fontSize: 14.0),
                          text: TextSpan(
                              style: const TextStyle(color: Colors.grey),
                              text:
                                  '${visitorCollectionList[index]['collectionDescription']}'),
                        ),
                        leading: AspectRatio(
                          aspectRatio: 1.5,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(1)),
                            child: Image.network(
                              visitorCollectionList[index]['collectionPicture'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        trailing: Text(visitorObject.visitorName),
                      ),
                    ),
                  );
                },
              );
              // return Text('Hass Data ${data.visitorCollections}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
