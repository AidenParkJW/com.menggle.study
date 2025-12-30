import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookSearch extends StatefulWidget {
  const BookSearch({super.key});

  @override
  State<BookSearch> createState() => _BookSearch();
}

class _BookSearch extends State<BookSearch> {
  late final List _list;
  late final TextEditingController _textCtrl;
  late final ScrollController _scrlCtrl;
  int _page = 1;
  bool _isEnd = false;
  int _totCnt = 0;

  @override
  void initState() {
    super.initState();

    _list = List.empty(growable: true);
    _textCtrl = TextEditingController();
    _scrlCtrl = ScrollController();

    _scrlCtrl.addListener(() {
      if (_scrlCtrl.offset >= _scrlCtrl.position.maxScrollExtent &&
          !_scrlCtrl.position.outOfRange) {
        if (!_isEnd) {
          _page++;
          getJsonData().then((value) {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textCtrl,
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요.'),
        ),
      ),
      body: _list.isEmpty
          ? Center(
            child: Text(
                '검색 결과가 없습니다.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
          )
          : ListView.builder(
              itemCount: _list.length + (!_isEnd ? 1 : 0),
              controller: _scrlCtrl,
              itemBuilder: (context, index) {
                
                if (index == _list.length) {
                  debugPrint("$index : ${_list.length}");
                  return const Center(child: CircularProgressIndicator());
                }
      
                return Card(
                  child: Row(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 20,
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      _list[index]['thumbnail'].toString().isNotEmpty
                          ? Image.network(
                              _list[index]['thumbnail'],
                              height: 100,
                              width: 90,
                              fit: BoxFit.contain,
                            )
                          : SizedBox(
                              height: 100,
                              width: 90,
                              child: Center(
                                child: Text(
                                  'No Image',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //     color: Colors.grey,
                            //     width: 1,
                            //   ),
                            // ),
                            child: Text(
                              "${_list[index]['title']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: Text("${_list[index]['authors']}"),
                          ),
                          Text("${_list[index]['sale_price']}"),
                          Text("${_list[index]['status']}"),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          _page = 1;
          _list.clear();
          _isEnd = false;

          getJsonData().then((value) {});
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> getJsonData() async {
    Map<String, dynamic>? jsonData;

    if (_textCtrl.value.text.isNotEmpty) {
      var url =
          "https://dapi.kakao.com/v3/search/book?target=title&query=${_textCtrl.value.text}&page=$_page";
      var response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "KakaoAK f84d4961e218c69c964cb1313bf68f0e"},
      );

      jsonData = json.decode(response.body);

      setState(() {
        List tempList = jsonData!['documents'];
        _isEnd = jsonData['meta']['is_end'];
        _totCnt = jsonData['meta']['total_count'];

        /* 
        for (var item in _tempList) {
          print("${item['title']} : ${item['thumbnail']}");
        }
 */
        _list.addAll(tempList);

        print(
          "page : $_page, 추가건수 : ${tempList.length}, 조회건수 : ${_list.length} / $_totCnt, 마지막: $_isEnd",
        );
      });
    }

    return jsonData;
  }
}
