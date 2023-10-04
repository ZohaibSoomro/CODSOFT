import 'package:flutter/material.dart';
import 'package:todo_list_codsoft/models/todo.dart';
import 'package:todo_list_codsoft/pages/todo_list.dart';

import 'add_todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int active = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Todos List'),
            centerTitle: true,
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'pending'),
                Tab(text: 'active'),
                Tab(text: 'completed'),
                Tab(text: 'deleted'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              // context.read<TodoProvider>().db.flushDb();
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => AddTodoScreen(),
              );
            },
            child: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          body: const TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TodoList(filter: TodoStatus.pending),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TodoList(filter: TodoStatus.active),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TodoList(filter: TodoStatus.completed),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TodoList(filter: TodoStatus.deleted),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
