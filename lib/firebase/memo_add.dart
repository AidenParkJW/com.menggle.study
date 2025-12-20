import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'memo.dart';

class MemoAdd extends StatefulWidget {
  const MemoAdd({super.key, required this.reference, required this.memo});

  final DatabaseReference reference;
  final Memo memo;

  @override
  State<MemoAdd> createState() => _MemoAdd();
}

class _MemoAdd extends State<MemoAdd> {
  late final TextEditingController _textCtrlTitle;
  late final TextEditingController _textCtrlContent;

  @override
  void initState() {
    super.initState();

    _textCtrlTitle = TextEditingController(text: widget.memo.title);
    _textCtrlContent = TextEditingController(text: widget.memo.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메모 추가')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _textCtrlTitle,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: "제목"),
              ),
              Expanded(
                child: TextField(
                  controller: _textCtrlContent,
                  keyboardType: TextInputType.multiline,
                  maxLines: 100,
                  decoration: const InputDecoration(labelText: '내용'),
                ),
              ),
              MaterialButton(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                child: const Text("저장하기"),
                onPressed: () {
                  Memo memo = Memo(
                      title: _textCtrlTitle.value.text,
                      content: _textCtrlContent.value.text,
                      createTime: DateTime.now().toIso8601String(),
                    );

                  if (widget.memo.key == null) {
                    widget.reference.push().set(memo.toJson()).then((value) => Navigator.of(context).pop());
                  } else {
                    widget.reference.child(widget.memo.key!).set(memo.toJson()).then((value) => Navigator.of(context).pop());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
