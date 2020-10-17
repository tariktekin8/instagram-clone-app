import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/User.dart';
import 'package:instagram_clone_app/widgets/UserActionsWidget.dart';
import 'package:instagram_clone_app/widgets/UserContentWidget.dart';
import 'package:instagram_clone_app/widgets/UserInfoDetailWidget.dart';
import 'package:instagram_clone_app/widgets/UserInfoWidget.dart';

class UserScreen extends StatefulWidget {
  final String username;

  UserScreen(this.username);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User user;

  @override
  void initState() {
    super.initState();

    setState(() {
      user = User(
        username: 'tariktekin8',
        name: 'Tarık Tekin',
        profileDescription: 'Hello I am Tarık !',
        profileImage:
            'https://firebasestorage.googleapis.com/v0/b/instagram-clone-app-2108b.appspot.com/o/tariktekin8.jpeg?alt=media&token=85e5c24a-4a7e-4c64-9541-be632e84fb81',
      );
    });

    // setState(() {
    //   user = User.fromDocument(widget.username);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          user.username,
          // style: TextStyle(fontFamily: GoogleFonts.nobile().fontFamily),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoWidget(user: user),
            UserInfoDetailWidget(user: user),
            UserActionsWidget(),
            // StoryListWidget(),
            UserContentWidget(),
          ],
        ),
      ),
    );
  }
}
