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
      title: 'Meeting with joDSDhn',
      description:
          'I have a meeting wSDFDith john  and do somanay other things that i would not tell you for now, so stay tuned to my channed for more info and details',
      isDone: false,
    ),
    Todo(
      id: '3',
      title: 'sfdsfsd',
      description:
          'I have a meeting wSDFDith john  and do somanay other things that i would not tell you for now, so stay tuned to my channed for more info and details',
      isDone: false,
    ),
    Todo(
      id: '4',
      title: 'Meeting fsfsfsdf joDSDhn',
      description:
          'I have a meeting wSDFDith john  and do somanay other things that i would not tell you for now, so stay tuned to my channed for more info and details',
      isDone: false,
    ),
    Todo(
      id: '5',
      title: 'Meeting with gssgsgsgsgs',
      description:
          'I have a meeting wSDFDith john  and do somanay other things that i would not tell you for now, so stay tuned to my channed for more info and details',
      isDone: false,
    ),
  ];

  List<Todo> get todos {
    List<Todo> completed = _todos.where((todo) => todo.isDone).toList();

    _todos.removeWhere((todo) => todo.isDone);
    _todos.addAll(completed.reversed);
    return [..._todos];
  }

  void addTodo(String title, String description) {
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

  void updateTodo(String id, Todo newTodo) {
    final oldIndex = _todos.indexOf(getTodo(id));
    _todos[oldIndex] = newTodo;
    notifyListeners();
  }

  Todo getTodo(String id) {
    return _todos.firstWhere((todo) => todo.id == id);
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  // toggles if a todo is completed or not
  void toogleDone(String id) {
    final todo = getTodo(id);
    todo.isDone = !todo.isDone;
    notifyListeners();
  }

  String todoPosition(Todo todo) {
    return (_todos.indexOf(todo) + 1).toString();
  }
}
