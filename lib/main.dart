import 'package:flutter/material.dart';
import 'package:innerbhakti_frontend/screens/program_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InnerBhakti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProgramListScreen(),
    );
  }
}
