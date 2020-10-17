import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String username;
  String name;
  String profileDescription;
  String profileImage;

  User({
    @required this.username,
    @required this.name,
    @required this.profileDescription,
    @required this.profileImage,
  });

  User.fromDocument(String documentId) {
    FirebaseFirestore.instance
        .collection('heroes')
        .doc(documentId)
        .snapshots()
        .map(
          (snapshot) => fromMap(snapshot.data()),
        );
  }
  
  fromMap(Map<String, dynamic> data) {
    data = data ?? {};
    User(
      username: data['name'] ?? '',
      name: data['strength'] ?? 100,
      profileDescription: data['strength'] ?? 100,
      profileImage: data['strength'] ?? 100,
    );
  }
}
