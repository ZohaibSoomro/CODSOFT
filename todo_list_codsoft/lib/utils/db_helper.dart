import 'dart:async';

import 'package:flutter/widgets.dart' show debugPrint;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';

class DbHelper {
  static DbHelper instance = DbHelper._init();
  DbHelper._init();
  Database? _database;
  static String dbName = "todos.db";
  static String tableName = "todolist";
  Future<Database> get database async => _database ??= await openDatabase(
        join(await getDatabasesPath(), dbName),
        version: 1,
        onCreate: _onCreate,
      );

  Future<void> _onCreate(Database db, int version) async {
    String query = '''
                  CREATE TABLE $tableName(
                    id TEXT PRIMARY KEY,
                    title TEXT,
                    description TEXT,
                    due_date TEXT,
                    timestamp TEXT,
                    status TEXT,
                    priority TEXT
                  )
                  ''';
    await db.execute(query);
    debugPrint("Table created");
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    var result = await db.insert(tableName, todo.toJson());
    debugPrint("data inserted $result");
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await instance.database;
    var result = await db.update(
      tableName,
      todo.toJson(),
      where: 'id=?',
      whereArgs: [todo.id],
    );
    debugPrint("data inserted $result");
  }

  Future<void> deleteTodo(String id) async {
    final db = await instance.database;
    var result = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint("data deleted $result");
  }

  Future<List<Todo>> getAllTodos() async {
    List<Todo> todos = [];
    final db = await database;
    try {
      final result = await db.query(tableName);
      for (final data in result) {
        final todo = Todo.fromJson(data);
        todos.add(todo);
      }
      debugPrint("All todos loaded");
    } catch (e) {
      debugPrint("Exception while getting todos: $e");
    }
    return todos;
  }

  Future<bool> recordExists(Todo todo) async {
    final db = await database;
    final result =
        await db.query(tableName, where: 'id = ?', whereArgs: [todo.id]);
    return result.isNotEmpty;
  }

  void flushDb() async {
    final db = await database;
    // db.close();
    // await db.execute('DROP TABLE IF EXISTS $tableName');
    await deleteDatabase(db.path);
    debugPrint("$dbName database flushed successfully");
  }
}
