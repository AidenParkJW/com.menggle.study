import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'memo.dart';
import 'memo_add.dart';

class MemoMain extends StatefulWidget {
  const MemoMain({super.key});

  @override
  State<MemoMain> createState() => _MemoMain();
}

class _MemoMain extends State<MemoMain> {
  FirebaseDatabase? _database;
  DatabaseReference? _reference;
  final String _databaseURL =
      'https://app-daonelab-com-default-rtdb.asia-southeast1.firebasedatabase.app';
  final List<Memo> _memoList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    _database = FirebaseDatabase.instance;
    _database!.databaseURL = _databaseURL;
    _reference = _database!.ref("memo");

    //_refreshlist();

    _reference!.onValue.listen((event) {
      debugPrint("------------------------------");
      debugPrint('조회 : ${event.snapshot.children.length}');
      debugPrint("------------------------------");

      setState(() {
        _memoList.clear();
        for (var snapshot in event.snapshot.children) {
          //debugPrint(snapshot.value.toString());
          _memoList.add(Memo.fromSnapshot(snapshot));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Realtime Database 메모 앱'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: _memoList.isEmpty
            ? CircularProgressIndicator()
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: _memoList.length,
                itemBuilder: (context, index) {
                  Memo memo = _memoList[index];

                  return Card(
                    child: GridTile(
                      header: Text(
                        memo.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      footer: Text(memo.createTime!.substring(0, 10)),
                      child: Container(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: GestureDetector(
                          child: Text(memo.content),
                          onTap: () {
                            _addMemo(memo);
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(memo.title),
                                  content: Text(
                                    '삭제하시겠습니까?',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _delMemo(memo);
                                      },
                                      child: const Text("예"),
                                    ),
                                    TextButton(
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
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _addMemo(Memo.newEmpty());
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

  Future<void> _refreshlist() async {
    try {
      DataSnapshot snapshotList = await _reference!.get();
      if (snapshotList.exists) {
        debugPrint("조회 : ${snapshotList.children.length}건");
        //print(_snapshotList.value); // Object?
        //print(_snapshotList.children);  //Iterable<DataSnapshot>

        setState(() {
          _memoList.clear();
          for (var snapshot in snapshotList.children) {
            //debugPrint(snapshot.value.toString());
            _memoList.add(Memo.fromSnapshot(snapshot));
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _addMemo(Memo memo) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            MemoAdd(reference: _reference!, memo: memo),
      ),
    );

    //_refreshlist();
  }

  void _delMemo(Memo memo) {
    _reference!
        .child(memo.key!)
        .remove()
        .then((value) => Navigator.of(context).pop());

    //_refreshlist();
  }
}
