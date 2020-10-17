import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Story {
  String username;
  String profileImage;

  Story({
    @required this.username,
    @required this.profileImage,
  });

  Story.fromDocument(String document) {
    FirebaseFirestore.instance.collection('stories').doc(document).get().then(
      (DocumentSnapshot snapshot) {
        this.username = snapshot.data()['username'];
        this.profileImage = snapshot.data()['profile_image'];
      },
    );
  }

  Story.fromDocumentSnapshot(DocumentSnapshot document) {
    this.username = document.data()['username'];
    this.profileImage = document.data()['profile_image'];
  }
}


