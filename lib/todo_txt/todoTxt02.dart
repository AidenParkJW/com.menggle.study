import 'package:flutter/material.dart';

class TodoTxt02 extends StatefulWidget {
  const TodoTxt02({super.key});

  @override
  State<TodoTxt02> createState() => _TodoTxt02();
}

class _TodoTxt02 extends State<TodoTxt02> {
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();

    _textCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final String todoName = ModalRoute.of(
      context,
    )!.settings.arguments.toString();
    _textCtrl.text = todoName;

    return Scaffold(
      appBar: AppBar(
        title: Text('할일 추가'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _textCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "할일"),
              style: TextStyle(fontSize: 30),
            ),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String _todoName = _textCtrl.value.text;

                    if (_todoName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: const Text('할일을 입력하세요.'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } else {
                      Navigator.of(context).pop(_todoName);
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
}
