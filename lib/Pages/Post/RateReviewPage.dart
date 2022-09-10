import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avatars/avatars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

void showRateReviewSheet(context, widget, location) {
  FirebaseFirestore db = FirebaseFirestore.instance;

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        double rating = 5;
        bool buttonLoading = false;
        var reviewFieldTextController = TextEditingController();
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.all(17.5),
              child: Wrap(
                children: [
                  const Text("Post Review",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 50),
                  RatingStars(
                    value: rating,
                    onValueChanged: (v) {
                      debugPrint(v.toString());
                      setState(() {
                        rating = v;
                      });
                    },
                    starBuilder: (index, color) => Icon(
                      Icons.star_rate_rounded,
                      color: color,
                      size: 50,
                    ),
                    starCount: 5,
                    starSize: 50,
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    minLines: 5,
                    maxLines: 10,
                    textAlignVertical: TextAlignVertical.top,
                    controller: reviewFieldTextController,
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (buttonLoading == true) return;
                        setState(() {
                          buttonLoading = true;
                        });
                        var loc = location['loc'];

                        final reviewData = {
                          'content': {
                            'rating': rating,
                            'review': reviewFieldTextController.text
                          },
                          "locData": location,
                          "uid": widget.user?.uid,
                          'formatted': location['formatted'],
                          "latLong": {
                            'lat': loc.latitude,
                            'long': loc.longitude
                          }
                        };
                        location.remove('loc');
                        db.collection("reviews").add(reviewData);
                        db
                            .collection("locationData")
                            .doc(location['geohash'])
                            .set(location);
                        Navigator.pop(context);
                      },
                      icon: !buttonLoading
                          ? const Icon(Icons.add)
                          : const CircularProgressIndicator(
                              color: Colors.black54),
                      label: Text(!buttonLoading ? 'Post' : ''),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ))
                ],
              ));
        });
      });
}
