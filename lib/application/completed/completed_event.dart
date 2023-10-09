
part of 'completed_bloc.dart';



abstract class TodoEvent {}

class CompletedCheckboxChangedEvent extends TodoEvent {
  final int index;
  final bool newState;

  CompletedCheckboxChangedEvent(this.index, this.newState);
}
class AddTodoEventToBoxCompleted1 extends TodoEvent {
  final String todoTitle;

  AddTodoEventToBoxCompleted1(this.todoTitle);
}




