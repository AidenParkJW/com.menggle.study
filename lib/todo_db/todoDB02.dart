import 'package:flutter/material.dart';

import 'todo.dart';

class TodoDB02 extends StatefulWidget {
  const TodoDB02({super.key, required this.todo});

  final Todo todo;

  @override
  State<TodoDB02> createState() => _TodoDB02();
}

class _TodoDB02 extends State<TodoDB02> {
  late final TextEditingController _textCtrlTitle;
  late final TextEditingController _textCtrlContent;
  bool? _isActive = false;

  @override
  void initState() {
    super.initState();

    _textCtrlTitle = TextEditingController(text: widget.todo.title);
    _textCtrlContent = TextEditingController(text: widget.todo.content);
    _isActive = widget.todo.isActive == 1;
  }

  @override
  void dispose() {
    _textCtrlTitle.dispose();
    _textCtrlContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할일 추가'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _textCtrlTitle,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: '제목'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _textCtrlContent,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: '할일'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text('완료여부'),
                  Checkbox(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        // 아래 로직 이어야 화면상에 변경내용이 반영된다.
                        _isActive = value;
                      });
                    },
                    activeColor: Colors.teal,
                    checkColor: Colors.white, 
                  ),
                ],
              ),
            ),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String _title = _textCtrlTitle.value.text;
                    String _content = _textCtrlContent.value.text;

                    if (_title.isEmpty) {
                      showAlert('제목을 입력하세요.');
                    } else if (_content.isEmpty) {
                      showAlert('할일을 입력하세요.');
                    } else {
                      Todo _todo = Todo(
                        id: widget.todo.id,
                        isActive: _isActive! ? 1 : 0,
                        title: _title,
                        content: _content,
                      );

                      Navigator.of(context).pop(_todo);
                    }
                  },
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.save), Text("저장")],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.cancel), Text("취소")],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showAlert(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
