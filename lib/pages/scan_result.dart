import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app/services/fetch_api.dart';

class ScanResult extends StatefulWidget {
  const ScanResult({super.key});

  @override
  State<ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)?.settings.arguments;
    // dynamic collectionDescription;
    // dynamic placeVisitorLists;
    // dynamic collectionPicture;
    // dynamic collectionCollector;
    // dynamic collectionUniqueID;
    // dynamic collectionIsCollected;
    // dynamic collectionName;
    // dynamic collectionPlace;
    // dynamic collectionProvince;

    return Scaffold(body: _bodyTravel(context, data)

        // SafeArea(
        //   child: Container(
        //     height: 300.0,
        //     // width: 700.0,
        //     decoration: BoxDecoration(
        //       color: const Color(0xff7c94b6),
        //       image: DecorationImage(
        //         image: NetworkImage(data['collectionPicture']),
        //         fit: BoxFit.fill,
        //       ),
        //       border: Border.all(
        //         width: 1,
        //       ),
        //       // borderRadius: BorderRadius.circular(12),
        //     ),
        //   ),
        // ),
        );
  }
}

Image getImage(dataImageUrl) {
  // NetworkImage(data['collectionPicture'])
  const maxWidth = '400';
  const maxHeight = '200';
  final url = dataImageUrl;
  return Image.network(url, fit: BoxFit.cover);
}

Widget _bodyTravel(BuildContext context, data) {
  return Center(
    child: CustomScrollView(
      slivers: [
        SliverAppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          expandedHeight: 350,
          flexibleSpace: FlexibleSpaceBar(
            background: getImage(data['collectionPicture']),
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 200.00,
          delegate: SliverChildListDelegate([
            buildSelectedDetails(context, data),
            // buildButtons(),
          ]),
        )
      ],
    ),
  );
}

Widget buildButtons(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 60,
      )
    ],
  );
}

Widget buildSelectedDetails(BuildContext context, data) {
  return Hero(
    tag: "SelectedTrip-${data['collectionName']}",
    transitionOnUserGestures: true,
    child: Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: SingleChildScrollView(
        child: Card(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              data!['collectionName'],
                              maxLines: 3,
                              style: const TextStyle(fontSize: 25.0),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          Text('${data['collectionDescription']}'),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                        children: [
                          Text(
                              "${data["collectionPlace"]} ${data['collectionProvince']}")
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
