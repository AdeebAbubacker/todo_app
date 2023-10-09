import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clud/core/adapters/completed/completed.dart';
import 'package:todo_clud/core/adapters/todo/todo.dart';
import 'package:todo_clud/core/boxes/boxes_completed.dart';
import 'package:todo_clud/core/boxes/boxes_todo.dart';

part 'completed_event.dart';
part 'completed_state.dart';

class CompletedBloc
    extends Bloc<CompletedCheckboxChangedEvent, CompletedState> {
  CompletedBloc() : super(CompletedState(List.filled(190, true))) {
//--Event------------------------- CompletedCheckboxChangedEvent ----------------------------------------//

    on<CompletedCheckboxChangedEvent>((event, emit) async {
      List<bool> updatedChecked = List.from(state.checked);
      updatedChecked[event.index] = event.newState;
      bool checkboxState = updatedChecked[event.index];
      Completed completed = boxCompleted.getAt(event.index);

      if (checkboxState == false) {
        emit(CompletedState(updatedChecked));
        await Future.delayed(const Duration(milliseconds: 500));

        updatedChecked[event.index] = true;
        emit(CompletedState(updatedChecked));

        if (boxCompleted.isNotEmpty) {
          boxTodo.put('key_${completed.name}', Todo(name: completed.name));
          await Future.delayed(const Duration(milliseconds: 200));
          await boxCompleted.deleteAt(event.index);
          updatedChecked.removeAt(event.index);
          emit(CompletedState(updatedChecked));
        } else {
          await Future.delayed(const Duration(milliseconds: 200));
          boxCompleted.deleteAt(event.index);
          updatedChecked.removeAt(event.index);
          emit(CompletedState(updatedChecked));
        }
      }
    });
  }
}
