import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:instagram_clone_app/models/ScreenState.dart';
import 'package:instagram_clone_app/screens/HomeScreen.dart';
import 'package:instagram_clone_app/screens/UserScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<NavigatorIcon> _navigatorIconList = [
    NavigatorIcon(icon: Icons.home, screenState: ScreenState.home),
    NavigatorIcon(icon: Icons.search, screenState: ScreenState.search),
    NavigatorIcon(
        icon: FontAwesome5.plus_square, screenState: ScreenState.post),
    NavigatorIcon(icon: Feather.heart, screenState: ScreenState.like),
    NavigatorIcon(icon: Icons.person_outline, screenState: ScreenState.user),
  ];

  ScreenState screenState = ScreenState.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreen(screenState),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _navigatorIconList.map<Widget>(
            (_navigatorIcon) {
              return IconButton(
                color: screenState == _navigatorIcon.screenState
                    ? Colors.blueAccent
                    : Colors.white,
                icon: Icon(_navigatorIcon.icon),
                onPressed: () {
                  if (screenState != _navigatorIcon.screenState) {
                    setState(() => screenState = _navigatorIcon.screenState);
                  }
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  getScreen(ScreenState state) {
    switch (state) {
      case ScreenState.home:
        return HomeScreen();
      case ScreenState.user:
        return UserScreen('tariktekin8');
      default:
        break;
    }
  }
}

class NavigatorIcon {
  IconData icon;
  ScreenState screenState;

  NavigatorIcon({this.icon, this.screenState});
}
