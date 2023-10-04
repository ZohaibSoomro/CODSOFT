import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_codsoft/pages/home.dart';
import 'package:todo_list_codsoft/state_management/todo_provider.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider()..loadAllTodos(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
