import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/api/graphql_config.dart';
import 'package:todo_app_with_graphql/othersScreen/custom_paint.dart';
import 'package:todo_app_with_graphql/provider/todos.dart';
import 'package:todo_app_with_graphql/screens/add_todo.dart';
import './screens/home.dart';

GraphQlConfig _config = GraphQlConfig();

void main() async {
  await initHiveForFlutter();
  runApp(GraphQLProvider(
    client: _config.getClient(),
    child: const CacheProvider(child: MyApp()),
  ));
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
          CustomPaintScreen.routeName: (_) => CustomPaintScreen(),
        },
      ),
    );
  }
}
