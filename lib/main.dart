import 'package:case_app/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.white,
        cardTheme: CardTheme(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 2.0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      title : 'Cases' ,
      home: Home(),
    );
  }
}
