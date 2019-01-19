import 'todo.dart';

abstract class Api {
  Future<List<Todo>> get all;
  Future add(Todo newItem);
  Future remove(Todo item);
  Future<Todo> toggle(Todo item);
}

class ListApi  extends Api {
  List<Todo> _items;

  ListApi({List<Todo> initial}) : this._items = initial ?? [];

  @override
  Future<List<Todo>> get all => Future.value(List.unmodifiable(_items));

  @override
  Future add(Todo newItem) {
     _items.add(newItem);
    return Future.value();
  }

  @override
  Future remove(Todo item) { 
    _items.remove(item);
    return Future.value();
  }

  @override
  Future<Todo> toggle(Todo item) { 
    Todo result;
    this._items = this._items.asMap().entries.map((e) {
      if(e.value.title == item.title) {
        result = Todo(!e.value.done, e.value.title);
        return result;
      }
      return e.value;
    }).toList();
    return Future.value(result);
  }
}