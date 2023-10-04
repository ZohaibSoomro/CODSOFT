import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_codsoft/models/todo.dart';
import 'package:todo_list_codsoft/state_management/todo_provider.dart';

import '../widgets/rounded_container.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  String? todoTitle;
  String dueDate = '';
  String todoDescription = "";
  TodoPriority priority = TodoPriority.normal;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: RoundedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Add Todo',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.004),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              decoration: const InputDecoration(hintText: 'title'),
              onChanged: (newValue) {
                setState(() {
                  todoTitle = newValue;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.002),
            TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'description'),
              style: const TextStyle(
                fontSize: 16.0,
              ),
              onChanged: (newValue) {
                setState(() {
                  todoDescription = newValue;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.003),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (dueDate.trim().isNotEmpty)
                  Text(Jiffy.parse(dueDate).yMMMEd),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                TextButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final dt = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: DateTime(now.year, 12),
                    );
                    if (dt != null) {
                      setState(() {
                        dueDate = dt.toIso8601String();
                        print(dueDate);
                      });
                    }
                  },
                  icon: Icon(Icons.date_range),
                  label: Text(
                    'Choose duedate',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.003),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("priority"),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: DropdownButton<TodoPriority>(
                    value: priority,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.blue,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    onChanged: (newValue) {
                      setState(() {
                        priority = newValue ?? TodoPriority.normal;
                      });
                    },
                    items: TodoPriority.values
                        .map<DropdownMenuItem<TodoPriority>>((value) {
                      return DropdownMenuItem<TodoPriority>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.006),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  if (todoTitle?.trim().isEmpty ?? true) {
                    Provider.of<TodoProvider>(context, listen: false)
                        .showMyToast("please add a title", bgColor: Colors.red);
                    return;
                  }
                  Provider.of<TodoProvider>(context, listen: false)
                      .addTodo(Todo(
                    title: todoTitle.toString(),
                    description: todoDescription,
                    priority: priority,
                    dueDate: dueDate,
                    timestamp: DateTime.now().toIso8601String(),
                  ));
                  print("'$todoTitle' added to todo list");
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
