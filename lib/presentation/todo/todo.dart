import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clud/application/todo/todo_bloc.dart';
import 'package:todo_clud/core/adapters/todo/todo.dart';
import 'package:todo_clud/core/boxes/boxes_todo.dart';
import 'package:todo_clud/presentation/homepage/notificationsheet.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<bool> checkboxList = []; 
  final titlecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateCheckboxList();
  }

  void updateCheckboxList() {
    checkboxList.clear();
    for (int i = 0; i < boxTodo.length; i++) {
      checkboxList.add(false); 
    }
  }

  void clearTextField() {
    titlecontroller.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('TodoApp'),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: boxTodo.length,
                      itemBuilder: (context, index) {
                        Todo todo = boxTodo.getAt(index);

                  

                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                                value: state.checked[
                                    index], 
                                onChanged: (value) {
                                  BlocProvider.of<TodoBloc>(context).add(
                                    CheckboxChangedEvent(index, value!, '1'),
                                  );
                                }),
                            title: Text(todo.name.toString()),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                BlocProvider.of<TodoBloc>(context).add(
                                  DeleteButtonEvent(
                                      index, state.checked[index]),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 500,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showNotificationSheet(context);

     
                      },
                      child: const Text('Add To Dos'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNotificationSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return NotificationSheet();
      },
    );

    // Refresh the list after closing the bottom sheet
    setState(() {
      updateCheckboxList();
    });
  }
}
