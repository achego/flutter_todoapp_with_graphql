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
  bool _loading = false;
  bool _deleteLoading = false;

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

  void _saveTodo() async {
    String message = '';
    setState(() {
      _loading = true;
    });
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
      try {
        await Provider.of<Todos>(context, listen: false)
            .addTodo(_title.text, _description.text);
        message = 'ADDED   "${_title.text}"';
      } catch (e) {
        message = 'AN ERROR OCURED !!!';
      }
      setState(() {
        _loading = false;
      });
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

  void _deleteTodo() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () async {
              String message = '';
              setState(() {
                _deleteLoading = true;
              });
              Navigator.pop(context);
              _showLoadingSpinner();
              try {
                await Provider.of<Todos>(context, listen: false)
                    .deleteTodo(_todo.id);
                message = 'ITEM DELETED SUCCESFULY';
              } catch (e) {
                message = 'COULD NOT DELETE ITEM';
              } finally {
                setState(() {
                  _deleteLoading = false;
                });
                Navigator.pop(context);
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: TextStyle(
                        color: message == 'COULD NOT DELETE ITEM!!!'
                            ? Colors.red
                            : null),
                  ),
                  action: SnackBarAction(
                    label: message == 'COULD NOT DELETE ITEM' ? "" : 'UNDO',
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

  _showLoadingSpinner() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text(
                'Deleting Item !!',
              ),
              content: SizedBox(
                height: 104,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    CircularProgressIndicator(),
                    Text(
                      'Please wait while we delete your item from the databse...',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ));
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
      body: SingleChildScrollView(
        child: Padding(
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
                onTap: _loading
                    ? () {}
                    : () {
                        _saveTodo();
                      },
                child: _loading
                    ? const FittedBox(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
