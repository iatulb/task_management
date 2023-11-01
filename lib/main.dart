
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:task_management/task_container.dart';
import 'package:task_management/task_list.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = '7nGCuYWhIFVolNfQbAV5FYZ9os12dRS9btePtcBO';
  const keyClientKey = 'GxvWqEYpWIdwA2pNdjetEwXEehpdxc3nOmknannz';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // _HomeState createState() => _HomeState();
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Management"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: const TaskContainer(title: 'Task List',)
    );
  }  
}