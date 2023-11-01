import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TaskList extends StatefulWidget {
  final setShowTaskForm;
  
  final setTaskData;

  const TaskList({super.key, required this.title, this.setShowTaskForm, this.setTaskData});

  final String title;

  @override
  State<TaskList> createState() => _TaskList();
}

class _TaskList extends State<TaskList> {

   bool done = false;
  
  

  @override
  Widget build(BuildContext context) {
    return         
        Expanded(
            child: FutureBuilder<List<ParseObject>>(
                future: getAllTasks(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Container(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()),
                      );
                    default:
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error..."),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Data..."),
                        );
                      } else {
                        return ListView.builder(
                            padding: const EdgeInsets.only(top: 10.0),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              //*************************************
                              //Get Parse Object Values
                              final varTodo = snapshot.data![index];
                              final varTitle = varTodo.get('title').toString()!;
                              final varDescription = varTodo.get<String>('description') ?? "";
                              final varDone = varTodo.get("done") ?? false;
                              //*************************************

                              return ListTile(
                                title: Text(varTitle),
                                subtitle: Text(varDescription),
                                onTap: (){
                                  widget.setShowTaskForm(true);
                                  widget.setTaskData(varTodo);
                                },
                                leading: CircleAvatar(
                                  backgroundColor:
                                      varDone ? Colors.green : Colors.orange,
                                  foregroundColor: Colors.white,
                                  child:
                                      Icon(varDone ? Icons.check : Icons.error),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MySwitch(done : varDone, objectId : varTodo.objectId),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () async {
                                        await deleteTask(varTodo.objectId!);
                                        setState(() {
                                          const snackBar = SnackBar(
                                            content: Text("Task deleted!"),
                                            duration: Duration(seconds: 2),
                                          );
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                  }
                }
              )      
    );
  }  
}


Future<List<ParseObject>> getAllTasks() async {
  QueryBuilder<ParseObject> queryTodo =
      QueryBuilder<ParseObject>(ParseObject('Task'));

  final ParseResponse apiResponse = await queryTodo.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<void> saveTodo(String title) async {
  await Future.delayed(Duration(seconds: 1), () {});
}

Future<void> updateTodo(String id, bool done) async {
  final task = ParseObject("Task")..objectId = id;
  task.set("done", done);
  await task.save();
}

Future<void> deleteTask(String id) async {
  final task = ParseObject("Task")..objectId = id;
  await task.delete();   
}

class MySwitch extends StatefulWidget{
  var done;
  
  var objectId;
  
  MySwitch({super.key, this.done=false, this.objectId});
 

  @override  
  State<MySwitch> createState() => _MySwitch();
}

class _MySwitch extends State<MySwitch>{
  
  @override
  Widget build(BuildContext context){ 
    return Switch(
      // This bool value toggles the switch.
      value: widget.done,
      activeColor: Colors.orange,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          widget.done = !widget.done;
        });
        updateTodo(widget.objectId, widget.done);
      },
    );
  }
}