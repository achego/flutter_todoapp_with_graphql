import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_graphql/models/todo.dart';
import 'package:todo_app_with_graphql/provider/todos.dart';
import '../widgets/custom_buttton.dart';
import '../widgets/custom_text_field.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  static const routeName = '/add-todo';

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  bool isInit = true;
  bool _disableButton = true;
  bool _editing = false;
  late Todo _todo;

  final TextEditingController _title = TextEditingController();

  final TextEditingController _description = TextEditingController();

  @override
  void didChangeDependencies() {
    if (isInit) {
      String todoId = '';
      try {
        todoId = ModalRoute.of(context)!.settings.arguments as String;
      } catch (e) {
        return;
      }

      if (todoId.isNotEmpty) {
        _todo = Provider.of<Todos>(context, listen: false).getTodo(todoId);
        _title.text = _todo.title;
        _description.text = _todo.description;
        _disableButton = false;
        _editing = true;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _description.dispose();
    _title.dispose();
    super.dispose();
  }

  void validateSaveButton() {
    setState(() {
      if (_title.text.isEmpty || _description.text.isEmpty) {
        _disableButton = true;
      } else {
        _disableButton = false;
      }
    });
  }

  void _saveTodo() {
    String message = '';
    bool noChange = false;
    if (_editing) {
      Todo newTodo = Todo(
        id: _todo.id,
        title: _title.text,
        description: _description.text,
        isDone: _todo.isDone,
      );
      Provider.of<Todos>(context, listen: false).updateTodo(_todo.id, newTodo);
      if (newTodo.title == _todo.title &&
          newTodo.description == _todo.description) {
        message = 'NO CHANGES MADE';
        noChange = true;
      } else {
        message = 'UPDATED   "${_title.text}"';
      }
    } else {
      Provider.of<Todos>(context, listen: false)
          .addTodo(_title.text, _description.text);
      message = 'ADDED   "${_title.text}"';
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: noChange ? '' : 'UNDO',
        textColor: Colors.orange,
        onPressed: () {
          print('yes');
        },
      ),
    ));
  }

  void _deleteTodo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<Todos>(context, listen: false).deleteTodo(_todo.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('ITEM DELETE SUCCESSFULL'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.orange,
                    onPressed: () {},
                  ),
                ),
              );
            },
            child: Text(
              'YES',
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
        ],
        title: Row(
          children: const [
            Text('Delete Item'),
            SizedBox(width: 20),
            Icon(
              Icons.not_interested,
              color: Colors.red,
            ),
          ],
        ),
        content: const Text('Are you sure you want to delete this item?'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        actions: [
          if (_editing)
            IconButton(
              onPressed: () {
                _deleteTodo();
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              onChanged: (_) {
                validateSaveButton();
              },
              controller: _title,
              hint: 'What do you want to do?',
            ),
            const SizedBox(height: 30),
            const Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              onChanged: (_) {
                validateSaveButton();
              },
              controller: _description,
              maxLines: 5,
              hint: 'Write wahat ',
            ),
            const SizedBox(height: 30),
            CustomButton(
              enabled: !_disableButton,
              onTap: () {
                _saveTodo();
              },
              title: 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
