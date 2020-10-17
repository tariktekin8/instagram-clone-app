import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone_app/screens/MainScreen.dart';
import 'package:instagram_clone_app/screens/LoadingScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone App',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.grey[900],
            fontFamily: GoogleFonts.nobile().fontFamily,
            textTheme: TextTheme(),
          ),
          home: _buildScreen(snapshot),
        );
      },
    );
  }

  dynamic _buildScreen(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return MainScreen();
    } else if (snapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Something Went Wrong !!!'),
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
