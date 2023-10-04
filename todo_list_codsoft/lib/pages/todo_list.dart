import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_codsoft/models/todo.dart';
import 'package:todo_list_codsoft/state_management/todo_provider.dart';
import 'package:todo_list_codsoft/widgets/todo_card.dart';

class TodoList extends StatelessWidget {
  final TodoStatus filter;

  const TodoList({super.key, this.filter = TodoStatus.completed});
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final todos =
            todoProvider.todos.where((todo) => todo.status == filter).toList();
        todos.sort((t1, t2) {
          return t1.dueDate.compareTo(t2.dueDate);
        });
        if (todos.isEmpty) {
          return Center(
              child: Text(
            'no todos in ${filter.name} state.',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ));
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "total(${todos.length})",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return TodoCard(todo: todos[index - 1]);
          },
          itemCount: todos.length + 1,
        );
      },
    );
  }
}
