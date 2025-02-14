import 'package:alco/models/stores/draw_grand_price.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

import 'dart:developer' as debug;

class WonGrandPriceWidget extends StatelessWidget {
  DrawGrandPrice wonPrice;
  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");

  WonGrandPriceWidget({
    required this.wonPrice,
  });

  Future<String> findWonPriceImageURL() async {
    return storageReference.child(wonPrice.imageURL).getDownloadURL();
  }

  String trimImageURL(String imageURL) {
    String newURL = imageURL.replaceFirst('%40', '@');
    newURL = newURL.replaceFirst('%3A', ':');

    return newURL;
  }

  AspectRatio retrieveWonPriceImage(BuildContext context, String imageURL) {
    return AspectRatio(
      aspectRatio: 7 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(trimImageURL(imageURL)),
            //image: NetworkImage(store.picPath + store.picName)
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: findWonPriceImageURL(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return retrieveWonPriceImage(context, snapshot.data as String);
              } else if (snapshot.hasError) {
                debug.log(
                    'Error Fetching Won Grand Price Image - ${snapshot.error}');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        Text(
          wonPrice.description,
          style: TextStyle(
              fontSize: MyApplication.infoTextFontSize,
              fontWeight: FontWeight.bold,
              color: MyApplication.logoColor1,
              decoration: TextDecoration.none),
        )
      ],
    );
  }
}
