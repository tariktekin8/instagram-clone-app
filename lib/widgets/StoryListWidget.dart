import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/Story.dart';
import 'package:instagram_clone_app/widgets/StoryWidget.dart';

class StoryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference stories =
        FirebaseFirestore.instance.collection('stories');

    return StreamBuilder<QuerySnapshot>(
      stream: stories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 90,
          child: _buildListWidget(snapshot),
        );
      },
    );
  }

  _buildListWidget(snapshot) {
    if (snapshot.hasError) {
      return Center(
        child: Text("Something went wrong !"),
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: Text("Loading..."),
      );
    }

    if (snapshot.connectionState == ConnectionState.active &&
        snapshot.data.docs != null) {
      return ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: snapshot.data.docs.map<Widget>(
          (DocumentSnapshot document) {
            return StoryWidget(
              story: Story.fromDocumentSnapshot(document),
            );
          },
        ).toList(),
      );
    }
  }
}
