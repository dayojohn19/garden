import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/services/place_data.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:app/services/fetch_api.dart';

class MyCollection extends StatefulWidget {
  const MyCollection({super.key});

  @override
  State<MyCollection> createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  List philippineregions = ['a'];
  Map data = {};
  // Append Each Place
  Future<List> fetchPlace() async {
    try {
      debugPrint('MyCollections');
      dynamic data = ModalRoute.of(context)?.settings.arguments;
      // var result = await rootBundle.loadString('assets/regions.json');
      FetchAPIservice instance =
          FetchAPIservice(subUrl: 'visitor', argumentsToPass: data);
      await instance.collectionAPI();
      instance.visitorName;
      instance.visitorCollections;
      instance.visitorVisitedPlace;
      // Map data = jsonDecode(result);
      data = instance;
      debugPrint('Pringting DATA new Value\n');
      debugPrint('$data');
      instance.visitorCollections.forEach(
        (key, value) {
          philippineregions.add(PlaceData(placeName: key, placeURL: 'none'));
          value.forEach((e) {
            philippineregions.add(PlaceData(placeName: e, placeURL: 'none'));
          });
        },
      );
      return philippineregions;
    } catch (e) {
      debugPrint('cant try');
      return philippineregions;
    }
    return philippineregions;
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
    fetchPlace();
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: const Text('View a Place'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          child: const SizedBox(
            height: 20,
          ),
        ));
  }
}
