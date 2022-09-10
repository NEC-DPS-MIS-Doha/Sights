import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map> topReview(location) async {
  var db = FirebaseFirestore.instance;
  var res = await db
      .collection("reviews")
      .where("formatted", isEqualTo: location?['formatted'])
      .get();
  if (res.docs.isEmpty) {
    return {'noData': true};
  }
  var reviewData = res.docs[0].data();
  debugPrint(reviewData.toString());
  var userData = await db
      .collection("userInfo")
      .doc(reviewData['uid'])
      .get() ;
  Map userInfo ={};
  debugPrint(userData.toString());

  if(!userData.exists){
    userInfo = {
      'name': 'Deleted User',
      'photoURL': '',
    };
  }else{
    userInfo = userData.data() as Map<String, dynamic>;
  }
  reviewData['user'] = userInfo;
  debugPrint(reviewData.toString());
  return Future.value(reviewData);
}
