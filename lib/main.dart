import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_clud/application/completed/completed_bloc.dart';
import 'package:todo_clud/application/todo/todo_bloc.dart';
import 'package:todo_clud/auth/splash_screen.dart';
import 'package:todo_clud/core/adapters/completed/completed.dart';
import 'package:todo_clud/core/adapters/todo/todo.dart';
import 'package:todo_clud/core/boxes/boxes_completed.dart';
import 'package:todo_clud/core/boxes/boxes_todo.dart';
import 'package:todo_clud/firebase_options.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  boxTodo = await Hive.openBox<Todo>('boxTodo');
  Hive.registerAdapter(CompletedAdapter());
  boxCompleted = await Hive.openBox<Completed>('boxCompleted');

  boxCompleted.put('key1', Completed(name: 'Task 1'));
  boxTodo.put('key1', Todo(name: ''));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TodoBloc(titleController: TextEditingController()),
        ),
        BlocProvider(
          create: (context) => CompletedBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
