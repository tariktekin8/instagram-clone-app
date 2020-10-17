import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/Story.dart';

class StoryWidget extends StatelessWidget {
  final Story story;

  const StoryWidget({
    Key key,
    this.story,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Color(0xFF8e44ad)),
              borderRadius: BorderRadius.circular(40),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
              child: Image(
                image: NetworkImage(story.profileImage),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            story.username,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
