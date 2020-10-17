import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:instagram_clone_app/widgets/StoryListWidget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Instagram Clone"),
        leading: IconButton(icon: Icon(Feather.camera), onPressed: () {}),
        actions: [
          IconButton(icon: Icon(FontAwesome.send_o), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.grey[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StoryListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
