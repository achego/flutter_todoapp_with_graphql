import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/provider/todos.dart';
import 'package:todo_app_with_graphql/screens/add_todo.dart';
import 'package:todo_app_with_graphql/widgets/todo_item.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<Todos>(context).todos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
          itemBuilder: (_, i) => TodoItem(
                todoItem: todos[i],
              ),
          itemCount: todos.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddTodo.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
