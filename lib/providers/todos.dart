import 'package:flutter/material.dart';
import 'package:todo_app_with_graphql/models/todo.dart';

class Todos with ChangeNotifier {
  final List<Todo> _todos = [
    Todo(
      id: '1',
      title: 'Meeting with john',
      description:
          'I have a meeting with john  and do somanay other things that i would not tell you for now, so stay tuned to my channed for more info and details',
      isDone: false,
    ),
    Todo(
      id: '2',
      title: 'Call Juliet',
      description: 'Discuss business with juliet',
      isDone: false,
    ),
  ];

  List<Todo> get todos {
    return [..._todos];
  }

  addTodo(String title, String description) {
    final id = DateTime.now().toString();
    _todos.add(
      Todo(
        id: id,
        title: title,
        description: description,
      ),
    );
    notifyListeners();
  }

  Todo getTodo(String id) {
    return _todos.firstWhere((todo) => todo.id == id);
  }

  void toogleDone(String id) {
    final todo = getTodo(id);
    final int ind = _todos.indexOf(todo);
    _todos.remove(todo);
    _todos.insert(
      ind,
      Todo(
        id: id,
        title: todo.title,
        description: todo.description,
        isDone: !todo.isDone,
      ),
    );
    print(todo.isDone);
    notifyListeners();
  }

  String todoPosition(Todo todo) {
    return (_todos.indexOf(todo) + 1).toString();
  }
}
