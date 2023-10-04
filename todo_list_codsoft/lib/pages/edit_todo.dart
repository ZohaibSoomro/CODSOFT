import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_codsoft/models/todo.dart';
import 'package:todo_list_codsoft/state_management/todo_provider.dart';

import '../widgets/rounded_container.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  const EditTodoScreen({super.key, required this.todo});
  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.title;
    descController.text = widget.todo.description;
    Future.delayed(Duration.zero).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
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
                    'Edit Todo',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.lightBlueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.004),
                  TextField(
                    autofocus: true,
                    controller: titleController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: const InputDecoration(hintText: 'title'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: descController,
                    decoration: const InputDecoration(hintText: 'description'),
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.006),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          Provider.of<TodoProvider>(context, listen: false)
                              .showMyToast("please add a title.");
                          return;
                        }
                        widget.todo.title = titleController.text.trim();
                        widget.todo.description = descController.text.trim();
                        Provider.of<TodoProvider>(context, listen: false)
                            .updateTodo(widget.todo);
                        print("'${titleController.text}' updated");
                        Navigator.pop(context);
                      },
                      child: const Text('Update'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
