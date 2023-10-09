import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_clud/core/adapters/completed/completed.dart';
import 'package:todo_clud/core/adapters/todo/todo.dart';
import 'package:todo_clud/core/boxes/boxes_completed.dart';
import 'package:todo_clud/core/boxes/boxes_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TextEditingController titleController;
  TodoBloc({required this.titleController})
      : super(TodoState(List.filled(190, false))) {
//--1st Event------------------------- AddTodoEventToBoxTodo ----------------------------------------//

    on<AddTodoEventToBoxTodo>((event, emit) async {
      List<bool> updatedChecked = List.from(state.checked);

      final todoName = event.todoTitle;
      final uniqueKey = DateTime.now();
      final todoKey = 'key_${uniqueKey}_${todoName}';

      // Check if the first index in boxTodo is empty
      if (boxTodo.length == 0 ||
              boxTodo.length <= 1 && boxTodo.getAt(0)?.name?.isEmpty ??
          true) {
        // put data to hive db
        boxTodo.putAt(
          0,
          Todo(
            name: event.todoTitle,
          ),
        );

        // put data to cloud_firestore

        try {
          FirebaseAuth _auth = FirebaseAuth.instance;
          var db = FirebaseFirestore.instance;
          final docRef = db
              .collection("user")
              .doc(_auth.currentUser!.email)
              .collection('todo')
              .doc(boxTodo.length.toString());
          await docRef.set({"todo": event.todoTitle});
          emit(TodoState(updatedChecked));
        } catch (e) {
          print("Error writing document: $e");
        }

        emit(TodoState(updatedChecked));
      } else {
        //Add Data to Hive
        boxTodo.put(
          todoKey,
          Todo(
            name: event.todoTitle,
          ),
        );

        // Add Data To Firebase
        try {
          FirebaseAuth _auth = FirebaseAuth.instance;
          var db = FirebaseFirestore.instance;
          final docRef = db
              .collection("user")
              .doc(_auth.currentUser!.email)
              .collection('todo')
              .doc(boxTodo.length.toString());
          await docRef.set({"todo": event.todoTitle});
          emit(TodoState(updatedChecked));
        } catch (e) {
          print("Error writing document: $e");
        }
      }

      emit(TodoState(updatedChecked));
    });

//--2nd Event------------------------- DeleteButtonEvent ----------------------------------------//

    on<DeleteButtonEvent>((event, emit) async {
      int myindex = event.index; // Get the index from the event

      List<bool> updatedChecked = List.from(state.checked);
      if (myindex >= 0 && myindex < updatedChecked.length) {
        // Check if boxTodo length is greater than 1
        if (boxTodo.length > 1) {
          //if boxtodo.length greater than 1 we should deleete boxtodo at selected index
          boxTodo.deleteAt(myindex);

//---------we tried to delete at index in cloud_firestore but index value not get properly

          // try {
          //   FirebaseAuth _auth = FirebaseAuth.instance;
          //   var db = FirebaseFirestore.instance;
          //   final docRef = db
          //       .collection("user")
          //       .doc(_auth.currentUser!.email)
          //       .collection('todo')
          //       .doc();
          //   await docRef.delete();
          //   emit(TodoState(updatedChecked));
          // } catch (e) {
          //   print("Error writing document: $e");
          // }
        } else if (boxTodo.length <= 1) {
          //as boxtodo.length < = 1 , then we should empty string
          boxTodo.putAt(0, Todo(name: ''));

//---------------------------------- as due to index problem we hault this delete

          // try {
          //   FirebaseAuth _auth = FirebaseAuth.instance;
          //   var db = FirebaseFirestore.instance;
          //   final docRef = db
          //       .collection("user")
          //       .doc(_auth.currentUser!.email)
          //       .collection('todo')
          //       .doc(myindex.toString());
          //   await docRef.delete();
          //   emit(TodoState(updatedChecked));
          // } catch (e) {
          //   print("Error writing document: $e");
          // }
        }
        updatedChecked[myindex] = event.newState;
        emit(TodoState(updatedChecked));
      }
    });

//--3 rd Event------------------------- CheckboxChangedEvent ----------------------------------------//

    on<CheckboxChangedEvent>((event, emit) async {
      List<bool> updatedChecked = List.from(state.checked);

      updatedChecked[event.index] = event.newState;
      bool checkboxState = updatedChecked[event.index];

      if (checkboxState) {
        Todo todo = boxTodo.getAt(event.index);
        if (boxTodo.length <= 1) {
          updatedChecked[event.index] = false;
          if (event.index == 0 && boxTodo.length <= 1) {
            if (todo.name.isNotEmpty) {
              boxCompleted.put('key', Completed(name: todo.name));
              boxTodo.putAt(0, Todo(name: ''));
            }
          }

          if (todo.name == '' && event.index == 0 && boxTodo.length <= 1) {
            updatedChecked[event.index] = false;
            boxTodo.putAt(0, Todo(name: ''));
          }
          emit(TodoState(updatedChecked));
        } else if (boxTodo.length > 1) {
          // Corrected 'else if'
          if (todo.name == '' && boxTodo.length > 1) {
            boxTodo.deleteAt(event.index);
            updatedChecked.removeAt(event.index);
            emit(TodoState(updatedChecked));
          } else {
            Todo todo = boxTodo.getAt(event.index);
            if (boxTodo.length > 1 && updatedChecked.length > 1) {
              boxCompleted.put('key_${todo.name}', Completed(name: todo.name));

              await boxTodo.deleteAt(event.index);
              updatedChecked.removeAt(event.index);
              emit(TodoState(updatedChecked));
            }

            emit(TodoState(updatedChecked));
          }
        }

        emit(TodoState(updatedChecked));
      }
    });
  }
}
