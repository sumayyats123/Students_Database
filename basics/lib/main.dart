import 'package:basics/addstudent.dart';
import 'package:basics/database/databasesqflite.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(MyApp());

}class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StudentDetailsPage(),debugShowCheckedModeBanner: false,);
  }
}
