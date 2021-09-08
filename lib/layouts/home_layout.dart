import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/constants/listData.dart';

import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late var scaffoldKey = GlobalKey<ScaffoldState>();
  late var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
            builder: (BuildContext context, state) => Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    title: Text(AppCubit.get(context)
                        .titles[AppCubit.get(context).currentIndex]),
                    centerTitle: true,
                  ),
                  body: /* AppCubit.get(context).newTasks.length == 0
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      :*/ AppCubit.get(context)
                          .screens[AppCubit.get(context).currentIndex],
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      if (AppCubit.get(context).bottomSheetShown) {
                        if (formKey.currentState!.validate()) {
                          AppCubit.get(context).insertToDatabase(
                              titleController.text.trim(),
                              dateController.text.trim(),
                              timeController.text.trim());
                        }
                      } else {
                        scaffoldKey.currentState!
                            .showBottomSheet(
                                (context) => Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(20.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              onTap: () {},
                                              controller: titleController,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                filled: true,
                                                labelText: "Task Title",
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black54),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black54)),
                                                prefixIcon: Icon(
                                                  Icons.title,
                                                  color: Colors.blueGrey,
                                                ),
                                                hintText: "Task Title",
                                                border: InputBorder.none,
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter the Title of the Task";
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            TextFormField(
                                              onTap: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                ).then((value) {
                                                  timeController.text =
                                                      value!.format(context);
                                                });
                                              },
                                              controller: timeController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                filled: true,
                                                labelText: "Task Time",
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black54),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black54)),
                                                prefixIcon: Icon(
                                                    Icons.watch_later_rounded,
                                                    color: Colors.blueGrey),
                                                hintText: "Task Title",
                                                border: InputBorder.none,
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter the Time of the Task";
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            TextFormField(
                                              onTap: () {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime.parse(
                                                                "2022-05-03"))
                                                    .then((value) {
                                                  print(DateFormat.yMMMd()
                                                      .format(value!));
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value);
                                                });
                                              },
                                              controller: dateController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                filled: true,
                                                labelText: "Task Date",
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black54),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black54)),
                                                prefixIcon: Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: Colors.blueGrey),
                                                hintText: "Task Date",
                                                border: InputBorder.none,
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter the Date of the Task";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                elevation: 20.0)
                            .closed
                            .then((value) {
                          AppCubit.get(context)
                              .changeBottomSheetState(false, Icons.edit);
                        });

                        AppCubit.get(context)
                            .changeBottomSheetState(true, Icons.add);
                      }
                    },
                    child: Icon(AppCubit.get(context).iconData),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      onTap: (index) {
                        AppCubit.get(context).changeIndex(index);
                      },
                      currentIndex: AppCubit.get(context).currentIndex,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.menu), label: "Tasks"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.check_circle_outline),
                            label: "Done"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.archive_outlined),
                            label: "Archived"),
                      ]),
                ),
            listener: (context, state) {
              if (state is AppInsertDatabaseState) {
                Navigator.pop(context);
              }
            }));
  }
}
