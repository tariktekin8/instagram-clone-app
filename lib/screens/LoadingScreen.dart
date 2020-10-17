import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  SpinKitChasingDots spinkit;

  @override
  void initState() {
    super.initState();

    spinkit = SpinKitChasingDots(
      color: Colors.grey[300],
      size: 50.0,
      // controller: AnimationController(
      //   vsync: this,
      //   duration: const Duration(milliseconds: 1000),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            spinkit,
            // Image.asset('assets/images/flutterlogo.png', width: 40, height: 40,),
            // SizedBox(
            //   height: 25,
            // ),
            // Text(
            //   "Splash Screen",
            //   style: GoogleFonts.nunito(
            //     fontSize: 20,
            //     textStyle: TextStyle(color: Colors.grey[200]),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
