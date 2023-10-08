import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clud/application/completed/completed_bloc.dart';
import 'package:todo_clud/core/adapters/completed/completed.dart';
import 'package:todo_clud/core/boxes/boxes_completed.dart';
import 'package:todo_clud/core/boxes/boxes_todo.dart';




// class CompletedPage extends StatefulWidget {
//   const CompletedPage({Key? key}) : super(key: key);

//   @override
//   State<CompletedPage> createState() => _CompletedPageState();
// }

// class _CompletedPageState extends State<CompletedPage> {
//   List<bool> checkboxList = []; // Use an empty list initially

//   @override
//   void initState() {
//     super.initState();
//     updateCheckboxList();
//   }

//   void updateCheckboxList() {
//     checkboxList.clear();
//     for (int i = 0; i < boxCompleted.length; i++) {
//       checkboxList.add(true); // Initialize with false values
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Text('CompletedPage'),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: boxCompleted.length,
//               itemBuilder: (context, index) {
//                 Completed completed = boxCompleted.getAt(index);
//                 return Card(
//                   child: ListTile(
//                     leading: Checkbox(
//                         value: checkboxList[index],
//                         onChanged: (value) {
//                           setState(() {
//                             checkboxList[index] = value!;
//                           });

//                           if (!checkboxList[index]) {
//                             Future.delayed(Duration(seconds: 1), () {
//                               setState(() {
//                                 boxTodo.put('key_${completed.name}',
//                                     Todo(name: completed.name));

//                                 boxCompleted.deleteAt(index);
//                                 updateCheckboxList();
//                               });
//                             });
//                           }
//                         }),
//                     title: Text(completed.name.toString()),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CompletedPage extends StatefulWidget {
  const CompletedPage({Key? key}) : super(key: key);

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  List<bool> checkboxList = []; // Use an empty list initially
  final titlecontroller = TextEditingController(); // Add this line

  @override
  void initState() {
    super.initState();
    updateCheckboxList();
  }

  void updateCheckboxList() {
    checkboxList.clear();
    for (int i = 0; i < boxTodo.length; i++) {
      checkboxList.add(false); // Initialize with false values
    }
  }

  void clearTextField() {
    titlecontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CompletedBloc, CompletedState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('TodoApp'),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: boxCompleted.length,
                        itemBuilder: (context, index) {
                          Completed completed = boxCompleted.getAt(index);

                          // Ensure that index is within the bounds of state.checkboxList

                          return Card(
                            child: ListTile(
                              leading: Checkbox(
                                  value: state.checked[
                                      index], // Use state.checked[index]
                                  onChanged: (value) {
                                    setState(() {
                                      value = false;
                                    });
                                    BlocProvider.of<CompletedBloc>(context).add(
                                      
                                      CompletedCheckboxChangedEvent(index, value!),
                                    );
                                  }),
                              title: Text(completed.name.toString()),
                            
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 500,
                      ),
                   
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}