part of 'todo_bloc.dart';

abstract class TodoEvent {}

class CheckboxChangedEvent extends TodoEvent {
  final int index;
  final bool newState;
  final String todoTitle;

  CheckboxChangedEvent(this.index, this.newState, this.todoTitle);
}

class DeleteButtonEvent extends TodoEvent {
  final int index;
  final bool newState;

  DeleteButtonEvent(this.index, this.newState);
}

class AddTodoEventToBoxTodo extends TodoEvent {
  final String todoTitle;

  AddTodoEventToBoxTodo(this.todoTitle);
}
