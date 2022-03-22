import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/models/todo.dart';
import 'package:todo_app_with_graphql/provider/todos.dart';
import 'package:todo_app_with_graphql/screens/add_todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todoItem;

  const TodoItem({Key? key, required this.todoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<Todos>(context, listen: false);

    Map<String, dynamic> allVariables = {
      'textDecoration': TextDecoration.lineThrough,
      'doneIcon': Icons.done,
      'inicatorColor': Colors.green.shade100,
      'inicatorBorder': Colors.green.shade400,
    };
    return ListTile(
      onTap: () => Navigator.of(context)
          .pushNamed(AddTodo.routeName, arguments: todoItem.id),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: todoItem.isDone
              ? allVariables['inicatorColor']
              : Colors.yellow.shade100,
          border: Border.all(
            color: todoItem.isDone
                ? allVariables['inicatorBorder']
                : Colors.yellow,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            todoItem.isDone ? todoItem.title[0] : todos.todoPosition(todoItem),
            style: TextStyle(
              fontSize: 14,
              color: todoItem.isDone
                  ? allVariables['inicatorBorder']
                  : Colors.yellow.shade700,
            ),
          ),
        ),
      ),
      title: Text(
        todoItem.title,
        style: TextStyle(
          decoration: todoItem.isDone
              ? allVariables['textDecoration']
              : TextDecoration.none,
        ),
      ),
      subtitle: TextField(
        enabled: false,
        decoration: InputDecoration(
          hintText: todoItem.description,
          hintStyle: TextStyle(
            fontSize: 14,
            decoration: todoItem.isDone
                ? allVariables['textDecoration']
                : TextDecoration.none,
          ),
          border: InputBorder.none,
          isCollapsed: true,
        ),
      ),
      trailing: GestureDetector(
        onTap: () => todos.toogleDone(todoItem.id),
        child: FittedBox(
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              color: todoItem.isDone ? Colors.green : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: todoItem.isDone
                ? Icon(
                    allVariables['doneIcon'],
                    color: Colors.white,
                    size: 22,
                  )
                : const Text(''),
          ),
        ),
      ),
    );
  }
}
