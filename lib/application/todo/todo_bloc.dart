import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
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
    on<AddTodoEventToBoxTodo>((event, emit) async {
      List<bool> updatedChecked = List.from(state.checked);
      String todoTitle = titleController.text;

      final todoName = event.todoTitle;
      final uniqueKey = DateTime.now();
      final todoKey = 'key_${uniqueKey}_${todoName}';

      // Check if the first index in boxTodo is empty
      if (boxTodo.length == 0 ||
              boxTodo.length <= 1 && boxTodo.getAt(0)?.name?.isEmpty ??
          true) {
        boxTodo.putAt(
          0,
          Todo(
            name: event.todoTitle,
          ),
        );
        try {
          FirebaseAuth _auth = FirebaseAuth.instance;
          var db = FirebaseFirestore.instance;

          // Your Firestore data to be stored
          final todoData = {"todo": event.todoTitle};

          // Define the Firestore document reference
          final docRef = db
              .collection("user")
              .doc(_auth.currentUser!.email)
              .collection('todo')
              .doc(boxTodo.length.toString());

          // Set the data to Firestore
          await docRef.set({"todo": event.todoTitle});

          // Emit the updated state if Firestore write is successful
          emit(TodoState(updatedChecked));
        } catch (e) {
          // Handle any errors here
          print("Error writing document: $e");
        }

        emit(TodoState(updatedChecked));
      } else {
        // Otherwise, add the new text at the end of boxTodo
        boxTodo.put(
          todoKey,
          Todo(
            name: event.todoTitle,
          ),
        );
        try {
          FirebaseAuth _auth = FirebaseAuth.instance;
          var db = FirebaseFirestore.instance;

          // Your Firestore data to be stored
          final todoData = {"todo": event.todoTitle};

          // Define the Firestore document reference
          final docRef = db
              .collection("user")
              .doc(_auth.currentUser!.email)
              .collection('todo')
              .doc(boxTodo.length.toString());

          // Set the data to Firestore
          await docRef.set({"todo": event.todoTitle});

          // Emit the updated state if Firestore write is successful
          emit(TodoState(updatedChecked));
        } catch (e) {
          // Handle any errors here
          print("Error writing document: $e");
        }
      }

      emit(TodoState(updatedChecked));
    });

    on<DeleteButtonEvent>((event, emit) async {
      int myindex = event.index; // Get the index from the event

      List<bool> updatedChecked = List.from(state.checked);
      if (myindex >= 0 && myindex < updatedChecked.length) {
        // Check if boxTodo length is greater than 1
        if (boxTodo.length > 1) {
          boxTodo.deleteAt(myindex);
          var check = boxTodo.length;

          try {
            FirebaseAuth _auth = FirebaseAuth.instance;
            var db = FirebaseFirestore.instance;

            // Define the Firestore document reference
            final docRef = db
                .collection("user")
                .doc(_auth.currentUser!.email)
                .collection('todo')
                .doc();

            // Set the data to Firestore
            await docRef.delete();

            // Emit the updated state if Firestore write is successful
            emit(TodoState(updatedChecked));
          } catch (e) {
            // Handle any errors here
            print("Error writing document: $e");
          }
        } else if (boxTodo.length <= 1) {
          boxTodo.putAt(0, Todo(name: ''));
          try {
            FirebaseAuth _auth = FirebaseAuth.instance;
            var db = FirebaseFirestore.instance;

            // Define the Firestore document reference
            final docRef = db
                .collection("user")
                .doc(_auth.currentUser!.email)
                .collection('todo')
                .doc(myindex.toString());

            // Set the data to Firestore
            await docRef.delete();

            // Emit the updated state if Firestore write is successful
            emit(TodoState(updatedChecked));
          } catch (e) {
            // Handle any errors here
            print("Error writing document: $e");
          }
        }

        // Put an empty string at index 0

        updatedChecked[myindex] = event.newState;

        // Emit the updated state with the modified checked list
        emit(TodoState(updatedChecked));
      }
    });
    on<CheckboxChangedEvent>((event, emit) async {
      List<bool> updatedChecked = List.from(state.checked);

      updatedChecked[event.index] = event.newState;
      bool checkboxState = updatedChecked[event.index];

      // Check if the checkbox state is still true (no user interaction occurred in the meantime)
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
          emit(TodoState(updatedChecked)); // Emit the updated state
        } else if (boxTodo.length > 1) {
          // Corrected 'else if'
          if (todo.name == '' && boxTodo.length > 1) {
            boxTodo.deleteAt(event.index);
            updatedChecked
                .removeAt(event.index); // Then remove from updatedChecked
            emit(TodoState(updatedChecked)); // Emit the updated state
          } else {
            Todo todo = boxTodo.getAt(event.index);
            if (boxTodo.length > 1 && updatedChecked.length > 1) {
              boxCompleted.put('key_${todo.name}', Completed(name: todo.name));

              await boxTodo.deleteAt(event.index); // Delete from boxTodo first
              updatedChecked
                  .removeAt(event.index); // Then remove from updatedChecked
              emit(TodoState(updatedChecked)); // Emit the updated state
            }

            emit(TodoState(updatedChecked)); // Emit the updated state
          }
        }

        emit(TodoState(updatedChecked)); // Emit the updated state
      }
    });
  }
}
