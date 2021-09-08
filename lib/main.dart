import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/layouts/home_layout.dart';

import 'constants/blocobserver.dart';


void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomeLayout(),
    );
  }
}

