import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avatars/avatars.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import 'package:flutter_star/flutter_star.dart';

void showRateReviewSheet(context, widget) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
          padding: const EdgeInsets.all(17.5),
          child: Wrap(
            children: [
              const Text("Post Review",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 50),
              CustomRating(
                  max: 6,
                  score: 3.0,

                  star: Star(

                      num: 12,
                      fillColor: Colors.orangeAccent,
                      fat: 0.6,
                      emptyColor: Colors.grey.withAlpha(88)),
                  onRating: (s) {
                    print(s);
                  }),
              const SizedBox(
                height: 50,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                minLines: 5,
                maxLines: 10,
                textAlignVertical: TextAlignVertical.top,
              ),
              SizedBox(
                height: 200,
              ),
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  label: Text('Post'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // NEW
                  ))
            ],
          ));
    },
  );
}
