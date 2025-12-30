import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LargeFile extends StatefulWidget {
  const LargeFile({super.key});

  @override
  State<LargeFile> createState() => _LargeFile();
}

class _LargeFile extends State<LargeFile> {
  bool isDownloading = false;
  String progressString = "";
  String filePath = "";
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();

    _textCtrl = TextEditingController(
      text:
          'https://images.pexels.com/photos/240041/pexels-photo-240041.jpeg?auto=compress',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textCtrl,
          style: TextStyle(color: Colors.blueGrey[700]),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: 'url을 입력하세요.'),
        ),
      ),
      body: Center(
        child: isDownloading
            ? SizedBox(
                height: 120,
                width: 200,
                child: Card(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Downloading File: $progressString',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            : FutureBuilder(
                future: loadImage(filePath),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      print('nome');
                      return Text('데이터 없음');

                    case ConnectionState.waiting:
                      print('waiting');
                      return CircularProgressIndicator(strokeWidth: 10);

                    case ConnectionState.active:
                      print('active');
                      return CircularProgressIndicator(strokeWidth: 10);

                    case ConnectionState.done:
                      print('done');
                      if (snapshot.hasData) {
                        return snapshot.data as Widget;
                      }
                  }
                  print('End Process');
                  return Text('연결없음');
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          donwnloadFile();
        },
        child: Icon(Icons.file_download),
      ),
    );
  }

  Future<void> donwnloadFile() async {
    Dio dio = Dio();

    try {
      //data/user/0/com.menggle.study/app_flutter/
      var dir = await getApplicationDocumentsDirectory();
      filePath = '${dir.path}/myimage.jpg';
      await dio.download(
        _textCtrl.value.text,
        filePath,
        onReceiveProgress: (rec, total) {
          //print('Rec: $rec, Total: $total');
          setState(() {
            isDownloading = true;
            progressString = '${((rec / total) * 100).round()} %';
          });
        },
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      isDownloading = false;
      progressString = "Completed";
    });

    print("Download Completed");
  }

  Future<Widget> loadImage(String filePath) async {
    //data/user/0/com.menggle.study/app_flutter/myimage.jpg
    //print(filePath);
    
    File file = File(filePath);
    bool isExist = await file.exists();
    await FileImage(file).evict();

    if (isExist) {
      return Center(child: Column(children: [Image.file(file)]));
    } else {
      return Text('No Data');
    }
  }
}
