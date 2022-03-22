class Todo {
  final String id;
  final String title;
  final String description;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });
}
