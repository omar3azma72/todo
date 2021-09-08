import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/constants/listData.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';

import 'states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() :super (AppInitialState());
  static AppCubit get(context)=> BlocProvider.of(context);

  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];
  int currentIndex = 0;
  late Database database;
  bool bottomSheetShown = false;
  IconData iconData = Icons.edit;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];

  void changeIndex (int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  void createDatabase()  {
     openDatabase("todo.db", version: 1,
        onCreate: (database, version) {
          print("Database Created");
          database
              .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)')
              .then((value) {
            print("Table Created");
          }).catchError((onError) {
            print("Error When Creating The Table ${onError.toString()}");
          });
        }, onOpen: (database) {
          getDataFromDatabase(database);
          print("Database Opened");
        }).then((value)
     {
       database=value;
      emit(AppGetDatabaseState());
    });
  }

   insertToDatabase(
      String title,
      String date,
      String time,
      ) async {
     await database.transaction((txn) {
      txn
          .rawInsert(
          "INSERT INTO Tasks (title , date  ,time , status) VALUES ('$title','$date','$time','New' ) ")
          .then((value) {
        print("$value inserted Successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);

      }).catchError((error) {
        print("Error When Inserting Values into The Table ${error.toString()}");
      });
      return Future<void>(() {});
    });
  }

  void updateData (String status , int id) async
  {
        database.rawUpdate('UPDATE Tasks SET status = ?  WHERE id = ?',
            ['$status', id]).then((value) {
              getDataFromDatabase(database);
              emit(AppUpdateDatabaseState());
        });

  }
  void deleteData ( int id) async
  {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteFromDatabaseState());
    });

  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    archivedTasks=[];
    doneTasks = [];
     emit(AppGetLoadingDatabaseState());
     database.rawQuery('SELECT * FROM Tasks').then((value)
     {
      value.forEach((element)
      {
          if(element['status']=="New"){
            newTasks.add(element);
          }
         else if(element['status']=="done"){
            doneTasks.add(element);
          }
         else archivedTasks.add(element);


      });
      emit(AppGetDatabaseState());
      print(newTasks);
      print(doneTasks);
      print(archivedTasks);
    });
  }
  void changeBottomSheetState(bool isShow , IconData icon){
    bottomSheetShown = isShow;
    iconData = icon;
    emit(AppChangeBottomSheetState());

  }
}