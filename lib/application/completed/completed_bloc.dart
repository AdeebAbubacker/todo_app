import 'package:bloc/bloc.dart';
import 'package:todo_clud/core/adapters/completed/completed.dart';
import 'package:todo_clud/core/adapters/todo/todo.dart';
import 'package:todo_clud/core/boxes/boxes_completed.dart';
import 'package:todo_clud/core/boxes/boxes_todo.dart';

part 'completed_event.dart';
part 'completed_state.dart';

class CompletedBloc
    extends Bloc<CompletedCheckboxChangedEvent, CompletedState> {
  CompletedBloc() : super(CompletedState(List.filled(190, true))) {
    on<CompletedCheckboxChangedEvent>((event, emit) async {
      List<bool> updatedChecked = List.from(state.checked);

      updatedChecked[event.index] = event.newState;
      bool checkboxState = updatedChecked[event.index];

      // Check if the checkbox state is still true (no user interaction occurred in the meantime)
      if (checkboxState == false) {
        // Todo todo = boxTodo.getAt(event.index);
        Completed completed = boxCompleted.getAt(event.index);
        if (completed.name == '') {
          boxCompleted.deleteAt(event.index);
          emit(CompletedState(updatedChecked)); // Emit the updated state
        } else {
          boxTodo.put('key_${completed.name}', Todo(name: completed.name));
          // boxTodo.add(completedItem); // Add to boxTodo
          await boxCompleted.deleteAt(event.index); // Delete from boxCompleted

          updatedChecked
              .removeAt(event.index); // Then remove from updatedChecked
          emit(CompletedState(updatedChecked)); // Emit the updated state
        }
      }
    });
  }
}
