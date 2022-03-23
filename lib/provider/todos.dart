import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app_with_graphql/api/graphql_config.dart';
import 'package:todo_app_with_graphql/api/query_mutation.dart';
import 'package:todo_app_with_graphql/models/todo.dart';

class Todos with ChangeNotifier {
  final List<Todo> _todos = [];

  final GraphQlConfig _config = GraphQlConfig();
  final QueryMutation _queryMutation = QueryMutation();

  List<Todo> get todos {
    List<Todo> completed = _todos.where((todo) => todo.isDone).toList();

    _todos.removeWhere((todo) => todo.isDone);
    _todos.addAll(completed.reversed);
    return [..._todos];
  }

  Future<void> getTodos() async {
    ValueNotifier<GraphQLClient> client = _config.getClient();
    QueryResult result = await client.value.query(
      QueryOptions(
        document: gql(
          _queryMutation.getTodos(),
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      print('GraphQl Exeptions  - ${result.exception}');
      return;
    }

    if (result.isNotLoading && !result.hasException) {
      // print(result.data!['getTodos']);
      List todoData = result.data!['getTodos'];
      for (var todoElement in todoData) {
        _todos.add(
          Todo(
            id: todoElement['id'].toString(),
            title: todoElement['task'].toString(),
            description: todoElement['timeAdded'].toString(),
            // isDone: todoElement['status'] != 'Pending',
          ),
        );
      }
    }
    notifyListeners();

    // print(result.data!['getTodos']);
  }

  Future<void> addTodo(String title, String description) async {
    ValueNotifier<GraphQLClient> client = _config.getClient();
    QueryResult result = await client.value.mutate(MutationOptions(
      document: gql(
        _queryMutation.createTodo(task: title),
      ),
    ));
    if (result.hasException) {
      // throw {result.exception};
      print('GraphQl Exeptions  - ${result.exception}');
      notifyListeners();
      // throw {result.exception};
    }

    if (result.isNotLoading && !result.hasException) {
      print(result.data!['createTodo']);
      Map todoData = result.data!['createTodo'];
      _todos.add(
        Todo(
          id: todoData['id'].toString(),
          title: todoData['task'].toString(),
          description: todoData['timeAdded'].toString(),
        ),
      );
    }
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

  Future<void> deleteTodo(String id) async {
    ValueNotifier<GraphQLClient> client = _config.getClient();
    QueryResult result = await client.value.mutate(
      MutationOptions(
        document: gql(
          _queryMutation.deleteTodo(int.parse(id)),
        ),
      ),
    );
    if (result.hasException) {
      print('GraphQl Exeptions  - ${result.exception}');
      throw {result.exception};
    }

    if (result.isNotLoading && !result.hasException) {
      _todos.removeWhere((todo) => todo.id == id);
    }
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
