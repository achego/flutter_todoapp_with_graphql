import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/provider/todos.dart';
import 'package:todo_app_with_graphql/screens/add_todo.dart';
import './screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Todos(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const Home(),
        routes: {
          AddTodo.routeName: (_) => AddTodo(),
        },
      ),
    );
  }
}
