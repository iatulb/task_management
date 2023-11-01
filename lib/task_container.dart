import 'package:flutter/material.dart';
import 'package:task_management/task_form.dart';
import 'package:task_management/task_list.dart';

class TaskContainer extends StatefulWidget {
  const TaskContainer({super.key, required this.title});

  final String title;

  @override
  State<TaskContainer> createState() => _TaskContainer();
}

class _TaskContainer extends State<TaskContainer> {

  bool showTaskForm = false;
  
  void _showTaskForm(){
    setState(() {
      showTaskForm = true;
      task = null;
    });
  }

  var task;
  
  void _setTaskData(data){
    setState(() {
      task = data;
    });
  }

  void _setShowTaskForm(bool flag){
    setState(() {
      showTaskForm = flag;
    });
  }


  @override
  Widget build(BuildContext context) {    
    return 
    showTaskForm ? 
      TaskForm(title: "Add Task", setShowTaskForm : _setShowTaskForm, taskData : task)
    :
    Column(
      children: [        
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.orangeAccent,
          ),
          onPressed: _showTaskForm,
          child: const Text("Add Task")
        ),
        TaskList(title:"Task List", setShowTaskForm : _setShowTaskForm, setTaskData:_setTaskData),        
      ],
    );
  }
  
}