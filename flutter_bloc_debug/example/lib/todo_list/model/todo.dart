class Todo {
  final String title;
  final bool done;
  Todo(this.done, this.title);

  @override
    String toString() => "$title [${done ? "✓" : "   "}]";
}