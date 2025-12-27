import 'package:flutter/material.dart';

class CalcMain extends StatefulWidget {
  const CalcMain({super.key});

  @override
  State<CalcMain> createState() => _CalcMainState();
}

class _CalcMainState extends State<CalcMain> {
  String sum = '';
  final TextEditingController _value1 = TextEditingController();
  final TextEditingController _value2 = TextEditingController();
  final _buttonList = ['더하기', '빼기', '곱하기', '나누기'];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = List.empty(
    growable: true,
  );
  String? _buttonText;

  @override
  void initState() {
    super.initState();

    for (var item in _buttonList) {
      _dropDownMenuItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
    _buttonText = _dropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("계산기"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('결과 : $sum', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _value1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _value2,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.amber),
                ),
                child: Row(children: [Icon(Icons.add), Text(_buttonText!)]),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      double value1Int = double.parse(_value1.value.text);
                      double value2Int = double.parse(_value2.value.text);
                      double result;

                      if (_buttonText == '더하기') {
                        result = value1Int + value2Int;
                      } else if (_buttonText == '빼기') {
                        result = value1Int - value2Int;
                      } else if (_buttonText == '곱하기') {
                        result = value1Int * value2Int;
                      } else {
                        result = value1Int / value2Int;
                      }
                      sum = '$result';
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: DropdownButton(
                items: _dropDownMenuItems,
                onChanged: (String? value) {
                  if (mounted) {
                    setState(() {
                      _buttonText = value;
                    });
                  }
                },
                value: _buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
