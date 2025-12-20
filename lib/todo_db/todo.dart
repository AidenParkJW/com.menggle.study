class Todo {
  int? id;
  int isActive;
  String title;
  String content;

  Todo({
    this.id,
    required this.isActive,
    required this.title,
    required this.content,
  });

  Todo.clone(Todo todo)
    : this(
        id: todo.id,
        isActive: todo.isActive,
        title: todo.title,
        content: todo.content,
      );

  Map<String, dynamic> toMap() {
    return {'id': id, 'isActive': isActive, 'title': title, 'content': content};
  }
}
