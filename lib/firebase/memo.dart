import 'package:firebase_database/firebase_database.dart';

class Memo {
  String? key;
  String title;
  String content;
  String? createTime;

  Memo({this.key, required this.title, required this.content, this.createTime});

  Memo.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      title = (snapshot.value as Map)['title'],
      content = (snapshot.value as Map)['content'],
      createTime = (snapshot.value as Map)['createTime'];

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'content': content,
      'createTime': createTime,
    };
  }

  Memo.newEmpty() : title = '', content = '';
}