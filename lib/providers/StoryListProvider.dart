import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/models/Story.dart';

class StoryListProvider {
  static List<Story> storyList;

  StoryListProvider();

  static getStoryList() {
    CollectionReference stories =
        FirebaseFirestore.instance.collection('stories');

    stories.get().then((querySnapshot) {
      querySnapshot.docs.forEach((snapshot) {
        storyList.add(
          Story(
            username: snapshot.data()['username'],
            profileImage: snapshot.data()['profile_image'],
          ),
        );
      });
    });
  }
}
