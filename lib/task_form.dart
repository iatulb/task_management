
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class TaskForm extends StatefulWidget{
  final String title;
  
  final setShowTaskForm;
  
  final taskData;
  
  const TaskForm({super.key, required this.title, this.setShowTaskForm, this.taskData, }); 
 

  @override  
  State<TaskForm> createState() => _TaskForm();
}

class _TaskForm extends State<TaskForm> {

  bool processing = false;

  TextEditingController titleController = TextEditingController();  
  TextEditingController descriptionController = TextEditingController();
  

  void _addTask() async{
    setState(() {
      processing = true;
    });
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Empty title"), 
          duration: Duration(seconds: 2),
        )
      );
    }

    final task = ParseObject("Task")..set("title", title)..set("description", description);
    await task.save();
    setState(() {
      processing = false;      
      widget.setShowTaskForm(false);
    });    
  }

  void updateTask(taskId) async{
    setState(() {
      processing = true;
    });
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Empty title"), 
          duration: Duration(seconds: 2),
        )
      );
    }

    final task = ParseObject("Task")
      ..set("title", title)
      ..set("description", description)
      ..set("objectId", taskId)
    ;    
    await task.save();
    setState(() {
      processing = false;      
      widget.setShowTaskForm(false);
    }); 
  }

  @override
  Widget build(BuildContext context){    
    return 
    processing ? 
    const SizedBox(
      width: 100,
      height: 100,
      child: CircularProgressIndicator(),
    )
    : 
    FutureBuilder<ParseObject?>(
      future: getByObjectId(widget.taskData != null && widget.taskData!.get("objectId").toString().isNotEmpty ? widget.taskData!.get("objectId").toString() : ""),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: SizedBox(
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
            // if (!snapshot.hasData) {
            //   return const Center(
            //     child: Text("No Data..."),
            //   );
            // } 
            else {
              return Container(
                padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                child: Column(
                  children: <Widget>[                    
                    TextField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        controller: titleController..text= widget.taskData != null && widget.taskData!.get("title").toString().isNotEmpty ? widget.taskData!.get("title") ?? "" : "",
                        decoration: const InputDecoration(
                            labelText: "New Task",
                            labelStyle: TextStyle(color: Colors.orangeAccent)),
                      ),
                    TextField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        controller: descriptionController..text= widget.taskData != null && widget.taskData!.get("description").toString().isNotEmpty ? widget.taskData!.get("description") ?? "" : "",
                        decoration: const InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(color: Colors.orangeAccent)),
                      ),
                      Row(
                        children: [                          
                          widget.taskData != null && widget.taskData!.get("objectId").toString().isNotEmpty 
                          ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Colors.orangeAccent,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),                      
                            ),
                            onPressed: (){
                              updateTask(widget.taskData!.get("objectId"));
                            },
                            child: const Text("Update"))
                          : 
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Colors.orangeAccent,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),                      
                            ),
                            onPressed: _addTask,
                            child: const Text("ADD")),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Colors.grey,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),                      
                            ),
                            onPressed: (){
                              setState(() {
                                processing = false;      
                                widget.setShowTaskForm(false);
                              }); 
                            },
                            child: const Text("Cancel")),
                        ],
                      )
                    
                  ],
                )
              );
            }
        }
      }
    );
  }
  
  Future<ParseObject?> getByObjectId(String objectId) async {
    // if (objectId.isEmpty) {
    //   ScaffoldMessenger.of(context)
    //     ..removeCurrentSnackBar()
    //     ..showSnackBar(
    //         const SnackBar(content: Text('None objectId. Click Save before.')));
    //   return null;
    // }
    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Task'))..whereEqualTo("objectId", objectId);

    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      final object = (apiResponse.results!.first) as ParseObject;
      return object;
    } else {
      return null;
    }
    // return null;
  }
}




