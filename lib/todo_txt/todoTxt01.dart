import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TodoTxt01 extends StatefulWidget {
  const TodoTxt01({super.key});

  @override
  State<TodoTxt01> createState() => _TodoTxt01();
}

class _TodoTxt01 extends State<TodoTxt01> {
  final List<String> todoList = List.empty(growable: true);
  String filePath = "";

  @override
  void initState() {
    super.initState();

    loadTodoList().then((value) {
      setState(() {
        todoList.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text File 할일 목록'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              child: Text(todoList[index], style: TextStyle(fontSize: 30)),
              onTap: () {
                _addTodo(index);
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('삭제'),
                      content: Text(
                        "'${todoList[index]}'을(를) 삭제하시겠습니까?",
                        style: TextStyle(fontSize: 30),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            _delTodo(index);

                            Navigator.of(context).pop();
                          },
                          child: const Text("예"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("아니오"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          _addTodo(null);
        }),
        child: Icon(Icons.post_add),
      ),
    );
  }

  Future<List<String>> loadTodoList() async {
    String todoString = "";
    var dir = await getApplicationDocumentsDirectory();
    filePath = '${dir.path}/todoList.txt';

    File file = File(filePath);
    bool isExists = await file.exists();
    print('파일존재여부: $isExists');
    if (!isExists) {
      todoString = ['당근 사오기', '약 사오기', '청소하기', '부모님께 전화하기'].join("\n");
      await file.writeAsString(todoString);
    }

    todoString = await file.readAsString();
    List<String> _todoList = todoString.split("\n");
    return _todoList;
  }

  void _addTodo(int? index) async {
    String todoName = "";
    
    if (index != null) {
      todoName = todoList[index];
    }

    final dynamic result = await Navigator.of(
      context,
    ).pushNamed("/todoTxt02", arguments: todoName);

    if (result != null) {
      setState(() {
        if (index != null) {
          todoList[index] = result as String;
        } else {
          todoList.add(result as String);
        }

        saveTodoList();
      });
    }
  }

  void _delTodo(int index) {
    setState(() {
      todoList.removeAt(index);

      saveTodoList();
    });
  }

  Future<void> saveTodoList() async {
    File file = File(filePath);
    String todoString = todoList.join("\n");
    await file.writeAsString(todoString);
  }
}
