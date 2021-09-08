import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => () {},
        builder: (context, state) => AppCubit.get(context).doneTasks.length != 0
            ? ListView.separated(
                itemBuilder: (context, index) =>
                    buildTask(AppCubit.get(context).doneTasks[index], context),
                separatorBuilder: (context, index) => Divider(
                      color: Colors.blueGrey,
                    ),
                itemCount: AppCubit.get(context).doneTasks.length)
            : Center(
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.menu,
                          color: Colors.blueAccent,
                          size: 60,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Tasks Are Empty Please Add one",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  margin:
                      EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                ),
              ));
  }

  Widget buildTask(Map model, BuildContext context) {
    return Dismissible(
      key: Key(model["id"].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(model["id"]);
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue,
                child: Text(
                  model["time"],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model["title"],
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      model["date"],
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateData("done", model["id"]);
                  },
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateData("archive", model["id"]);
                  },
                  icon: Icon(
                    Icons.archive,
                    color: Colors.orange,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
