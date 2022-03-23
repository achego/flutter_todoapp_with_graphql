import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/othersScreen/custom_paint.dart';
import 'package:todo_app_with_graphql/provider/todos.dart';
import 'package:todo_app_with_graphql/screens/add_todo.dart';
import 'package:todo_app_with_graphql/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Todos>(context, listen: false).getTodos().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<Todos>(context).todos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CustomPaintScreen.routeName);
            },
            icon: const Icon(Icons.forward),
          ),
        ],
      ),
      body: todos.isEmpty && !_isLoading
          ? const Center(
              child: ListTile(
                title: Text(
                  'Todos is Empty',
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  'Click the Floating Button to add a todo',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : ListView.builder(
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
