import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_list_codsoft/utils/db_helper.dart';

import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final DbHelper _helper = DbHelper.instance;
  List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos {
    return UnmodifiableListView(_todos);
  }

  DbHelper get db => _helper;

  int get todoCount {
    return _todos.length;
  }

  deleteDb() {
    _helper.flushDb();
    notifyListeners();
  }

  Future<void> loadAllTodos() async {
    _todos = await _helper.getAllTodos();
    notifyListeners();
  }

  Future<bool> todoExists(Todo book) async {
    return _helper.recordExists(book);
  }

  updateTodo(Todo todo) async {
    await _helper.updateTodo(todo);
    loadAllTodos();
  }

  deleteTodo(Todo todo) async {
    await _helper.deleteTodo(todo.id);
    loadAllTodos();
  }

  void showMyToast(String content, {Color bgColor = Colors.blue}) {
    Fluttertoast.showToast(msg: content, backgroundColor: bgColor);
  }

  void addTodo(Todo todo) {
    todo.id = DateTime.now().millisecondsSinceEpoch.toString();
    _helper.insertTodo(todo);
    loadAllTodos();
    notifyListeners();
  }
}
