import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'DBHelper.dart';
import 'todo.dart';
import 'todoDB02.dart';

class TodoDB01 extends StatefulWidget {
  final DBHelper _dbHelper = DBHelper.getInstance();

  TodoDB01({super.key});

  @override
  State<TodoDB01> createState() => _TodoDB01();
}

class _TodoDB01 extends State<TodoDB01> {
  late Future<List<Todo>> _todoList;

  @override
  void initState() {
    super.initState();

    _refreshlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqlite DB 할일 목록'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Center(
        child: FutureBuilder(
          future: _todoList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List<Todo> todoList = snapshot.data as List<Todo>;

                  return todoList.isEmpty
                      ? Text('No data')
                      : ListView.builder(
                          itemCount: todoList.length,
                          itemBuilder: (context, index) {
                            Todo todo = todoList[index];

                            return ListTile(
                              leadingAndTrailingTextStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              leading: Text('${todo.id}'),
                              title: Text(todo.title),
                              subtitle: Text(
                                todo.content,
                                style: const TextStyle(fontSize: 30),
                              ),
                              trailing: Text(
                                "달성여부 : ${todo.isActive == 1 ? '예' : '아니오'}",
                              ),

                              onTap: () {
                                _addTodo(Todo.clone(todo));
                              },
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('${todo.id} : ${todo.title}'),
                                      content: Text(
                                        "'${todo.content}'을(를) 삭제하시겠습니까?)",
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _deleteTodo(todo);

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('예'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('아니오'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                } else {
                  return Text('Error Occured');
                }
            }
          },
        ),
      ),
      floatingActionButton: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _addTodo(Todo(isActive: 0, title: "", content: ""));
            },
            heroTag: null,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              _refreshlist();
            },
            heroTag: null,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void _addTodo(Todo todo) async {
    dynamic todo0 = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => TodoDB02(todo: todo)));

    if (todo0 != null) {
      if (todo0.id == null) {
        _insertTodo(todo0 as Todo);
      } else {
        _updateTodo(todo0 as Todo);
      }
    }
  }

  Future<List<Todo>> _selTodoList() async {
    Database db = await widget._dbHelper.database;
    final List<Map<String, dynamic>> todoList = await db.query(
      'TODO',
      orderBy: "ID ASC",
    );

    // print("조회 : ${todoList.length}");

    // for (var p in todoList) {
    //   print("${p['ID']}, ${p['TITLE']}, ${p['CONTENT']}, ${p['ISACTIVE']}");
    // }

    return List.generate(todoList.length, (i) {
      return Todo(
        id: todoList[i]['ID'],
        isActive: todoList[i]['ISACTIVE'],
        title: todoList[i]['TITLE'],
        content: todoList[i]['CONTENT'],
      );
    });
  }

  void _refreshlist() {
    setState(() {
      _todoList = _selTodoList();
    });
  }

  Future<int> _insertTodo(Todo todo) async {
    Database db = await widget._dbHelper.database;
    int id = await db.insert(
      'TODO',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _refreshlist();

    // 생성된 ID
    print("Insert Todo ID : $id");
    return id;
  }

  Future<int> _updateTodo(Todo todo) async {
    Database db = await widget._dbHelper.database;
    int id = await db.update(
      'TODO',
      todo.toMap(),
      where: "ID = ?",
      whereArgs: [todo.id],
    );

    _refreshlist();

    // 업데이트된 건수
    print("Updated count : $id");
    return id;
  }

  Future<int> _deleteTodo(Todo todo) async {
    Database db = await widget._dbHelper.database;
    int id = await db.delete('TODO', where: "ID = ?", whereArgs: [todo.id]);

    _refreshlist();

    // 삭제된 건수
    print("Deleted count : $id");
    return id;
  }
}
