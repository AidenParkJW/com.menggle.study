import 'package:flutter/material.dart';

import 'animal.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.animalList});
  final List<Animal> animalList;

  @override
  State<SecondPage> createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  int? _radioValue = 0;
  bool? _flyExist = false;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextField(keyboardType: .text, maxLines: 1, controller: _nameCtrl),
            RadioGroup<int>(
              groupValue: _radioValue,
              onChanged: _radioChange,
              child: Column(
                children: [
                  RadioListTile<int>(title: const Text('양서류'), value: 0),
                  RadioListTile<int>(title: const Text('파충류'), value: 1),
                  RadioListTile<int>(title: const Text('포유류'), value: 2),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: .center,
              children: [
                Text('날 수 있나요?'),
                Checkbox(value: _flyExist, onChanged: _checkChange),
              ],
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: .horizontal,
                children: [
                  GestureDetector(
                    child: Image.asset('images/bee.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/bee.png';
                    },
                  ),
                  GestureDetector(
                    child: Image.asset('images/cat.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/cat.png';
                    },
                  ),
                  GestureDetector(
                    child: Image.asset('images/cow.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/cow.png';
                    },
                  ),
                  GestureDetector(
                    child: Image.asset('images/dog.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/dog.png';
                    },
                  ),
                  GestureDetector(
                    child: Image.asset('images/fox.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/fox.png';
                    },
                  ),
                  GestureDetector(
                    child: Image.asset('images/monkey.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/monkey.png';
                    },
                  ),
                  GestureDetector(
                    child: Image.asset('images/pig.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/pig.png';
                    },
                  ),
                  GestureDetector(
                    child: Image.asset('images/wolf.png', width: 80),
                    onTap: () {
                      _imagePath = 'images/wolf.png';
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: _addAnimal, child: Text('동물 추가하기')),
          ],
        ),
      ),
    );
  }

  void _radioChange(int? value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _checkChange(bool? value) {
    setState(() {
      _flyExist = value;
    });
  }

  void _addAnimal() {
    setState(() {
      Animal animal = Animal(
        imagePath: _imagePath,
        animalName: _nameCtrl.value.text,
        kind: _getKind(_radioValue),
        flyExists: _flyExist,
      );

      AlertDialog dialog = AlertDialog(
        title: Text('동물 추가하기'),
        content: Text(
          "이름 : ${animal.animalName}\n"
          "종류 : ${animal.kind}\n"
          "이 동물을 추가하시겠습니까?",
          style: TextStyle(fontSize: 30.0),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.animalList.add(animal);

              print(widget.animalList.length);
              for (var ani in widget.animalList) {
                print('${ani.animalName} : ${ani.imagePath}');
              }

              Navigator.of(context).pop();
            },
            child: Text("예"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("아니오"),
          ),
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    });
  }

  String? _getKind(int? radioValue) {
    String? result;

    switch (radioValue) {
      case 0:
        result = '양서류';
        break;
      case 1:
        result = '파충류';
        break;
      case 2:
        result = '포유류';
        break;
    }

    return result;
  }
}
