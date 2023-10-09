import 'package:flutter/material.dart';
import 'package:todo_clud/presentation/completed/completed.dart';
import 'package:todo_clud/presentation/todo/todo.dart';



class TodoPagePage extends StatefulWidget {
  const TodoPagePage({Key? key}) : super(key: key);

  @override
  State<TodoPagePage> createState() => _TodoPagePageState();
}

class _TodoPagePageState extends State<TodoPagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'TodoPage'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TodoPage(),
          CompletedPage(),
        ],
      ),
    );
  }
}
