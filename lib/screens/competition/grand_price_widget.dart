import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import '../../../controllers/store_controller.dart';
import "dart:developer" as debug;

// Branch : competition_resources_crud ->  view_competitions
class GrandPriceWidget extends StatefulWidget {
  String grandPriceImageURL;
  AlignmentGeometry? alignmentGeometry;
  bool isPointed;
  bool showBall;

  GrandPriceWidget({
    super.key,
    required this.grandPriceImageURL,
    this.alignmentGeometry = Alignment.centerLeft,
    this.showBall = false,
    this.isPointed = false,
  });

  @override
  GrandPriceWidgetState createState() => GrandPriceWidgetState();
}

class GrandPriceWidgetState extends State<GrandPriceWidget> {
  StoreController storeController = StoreController.storeController;
  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");

  Future<String> retrieveGrandPriceImageURL() {
    return storageReference.child(widget.grandPriceImageURL).getDownloadURL();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget showGrandPrice() {
    return FutureBuilder(
        future: retrieveGrandPriceImageURL(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(snapshot.data! as String),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            debug.log(
                'Error Fetching Draw Grand Price Image - ${snapshot.error}');
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: showGrandPrice(),
      );
}
