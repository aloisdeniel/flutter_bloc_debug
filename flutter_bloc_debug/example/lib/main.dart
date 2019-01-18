import 'package:example/todo_list/todo_list.dart';
import 'package:flutter/material.dart';
import 'counter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Map<String, WidgetBuilder> examples = {
    'Counter': (c) => CounterView(),
    'TodoList': (c) => TodoListView(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final entries = examples.entries.toList();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Examples")),
        body: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (c, i) => Card(
                margin: EdgeInsets.all(16.0),
                child: ListTile(
                  onTap: () {
                    Navigator.of(c).push(MaterialPageRoute(
                      builder: (c) => entries[i].value(c),
                    ));
                  },
                  title: Text(entries[i].key),
                ))),
      ),
    );
  }
}
