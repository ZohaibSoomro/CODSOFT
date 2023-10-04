import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_codsoft/models/todo.dart';

import '../pages/edit_todo.dart';
import '../state_management/todo_provider.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.blue,
        textColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              todo.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (todo.status == TodoStatus.pending)
                  Column(
                    children: [
                      const Text(
                        'active',
                        style: TextStyle(fontSize: 14),
                      ),
                      Checkbox(
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        focusColor: Colors.white,
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => todo.status == TodoStatus.pending
                              ? Colors.white
                              : Colors.grey.shade400,
                        ),
                        value: todo.status == TodoStatus.active,
                        onChanged: todo.status != TodoStatus.pending
                            ? null
                            : (val) {
                                if (val == null) return;
                                if (val) {
                                  todo.status = TodoStatus.active;
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .updateTodo(todo);
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .showMyToast("todo is active now");
                                }
                              },
                      ),
                    ],
                  ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                if (todo.status == TodoStatus.active)
                  Column(
                    children: [
                      const Text(
                        'completed',
                        style: TextStyle(fontSize: 14),
                      ),
                      Checkbox(
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        focusColor: Colors.white,
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => todo.status != TodoStatus.deleted
                              ? Colors.white
                              : Colors.grey.shade400,
                        ),
                        value: todo.status == TodoStatus.completed,
                        onChanged: todo.status == TodoStatus.deleted ||
                                todo.status == TodoStatus.completed
                            ? null
                            : (val) {
                                if (val == null) return;
                                if (val) {
                                  todo.status = TodoStatus.completed;
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .updateTodo(todo);
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .showMyToast("todo marked as completed");
                                }
                              },
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.description.isEmpty
                      ? 'description not found'
                      : todo.description,
                  style: TextStyle(
                    color: todo.description.isEmpty
                        ? Colors.white54
                        : Colors.white,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: todo.status == TodoStatus.deleted ||
                              todo.status == TodoStatus.completed
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTodoScreen(todo: todo),
                                ),
                              );
                            },
                      child: Chip(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        backgroundColor: todo.status != TodoStatus.deleted
                            ? Colors.white
                            : Colors.black12,
                        label: const Icon(Icons.edit, color: Colors.blue),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        if (todo.status == TodoStatus.deleted) {
                          Provider.of<TodoProvider>(context, listen: false)
                              .deleteTodo(todo);
                          Provider.of<TodoProvider>(context, listen: false)
                              .showMyToast("todo permanently deleted.");
                        } else {
                          todo.status = TodoStatus.deleted;
                          Provider.of<TodoProvider>(context, listen: false)
                              .updateTodo(todo);
                          Provider.of<TodoProvider>(context, listen: false)
                              .showMyToast("todo deleted.");
                        }
                      },
                      child: Chip(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        backgroundColor: todo.status != TodoStatus.deleted
                            ? Colors.white
                            : Colors.black12,
                        label: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 37,
                      child: Row(
                        children: [
                          const Text("Status: "),
                          Chip(
                            label: Text(todo.status.name),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 37,
                      child: Row(
                        children: [
                          const Text("Priority: "),
                          Chip(
                            label: Text(todo.priority.name),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (todo.status != TodoStatus.deleted &&
                    todo.dueDate.trim().isNotEmpty)
                  Text("duedate: ${Jiffy.parse(todo.dueDate).yMMMEd}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
