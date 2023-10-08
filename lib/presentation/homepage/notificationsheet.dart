import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clud/application/todo/todo_bloc.dart';


class NotificationSheet extends StatelessWidget {
  NotificationSheet({super.key});

  final titlecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add To Do in my app',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: titlecontroller,
            decoration: const InputDecoration(labelText: 'Enter Todo Title'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              final todoName = titlecontroller.text;
              BlocProvider.of<TodoBloc>(context)
                  .add(AddTodoEventToBoxTodo(todoName));
              titlecontroller.clear();
              Navigator.of(context).pop(); // Close the bottom sheet
            },
            child: const Text("Add Todo"),
          ),
        ],
      ),
    );
  }
}
