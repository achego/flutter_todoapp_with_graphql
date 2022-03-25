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
  Map<String, String> _error = {
    'title': 'Todos is Empty',
    'sub': 'Click the Floating Button to add a todo',
  };

  Future<void> refresh() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Todos>(context, listen: false).getTodos();
    } catch (e) {
      setState(() {
        _error = {
          'title': 'An Error Occured',
          'sub': 'check your internet connection then swipe down to refresh',
        };
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      refresh();
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<Todos>(context).todos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo list'),
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
          ? RefreshIndicator(
              onRefresh: () => refresh(),
              child: Center(
                child: ListTile(
                  title: Text(
                    _error['title']!,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    _error['sub']!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : RefreshIndicator(
                  onRefresh: () => refresh(),
                  child: ListView.builder(
                      itemBuilder: (_, i) => TodoItem(
                            todoItem: todos[i],
                          ),
                      itemCount: todos.length),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading
            ? () {}
            : () {
                Navigator.of(context).pushNamed(AddTodo.routeName);
              },
        child: const Icon(Icons.add),
        backgroundColor: _isLoading ? Colors.grey : null,
      ),
    );
  }
}
