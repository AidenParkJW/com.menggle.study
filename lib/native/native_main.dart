import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeMain extends StatefulWidget {
  const NativeMain({super.key});

  @override
  State<NativeMain> createState() => _NativeMain();
}

class _NativeMain extends State<NativeMain> {
  static const platform1 = MethodChannel('com.flutter.dev/info');
  static const platform2 = MethodChannel('com.flutter.dev/encrypto');
  static const platform3 = MethodChannel('com.flutter.dev/dialog');
  String _deviceInfo = "Unknown info.";
  String _encodeText = "";
  String _decodeText = "";

  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();

    _textCtrl = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Native 통신')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Device Info. :', style: const TextStyle(fontSize: 20)),
          Text(_deviceInfo, style: const TextStyle(fontSize: 20)),
          Divider(height: 10, thickness: 3, color: Colors.blue),
          Text('Encode', style: const TextStyle(fontSize: 20)),
          TextField(controller: _textCtrl, keyboardType: TextInputType.text),
          Text(_encodeText, style: const TextStyle(fontSize: 20)),
          Text('Decode', style: const TextStyle(fontSize: 20)),
          Text(_decodeText, style: const TextStyle(fontSize: 20)),
          Divider(height: 10, thickness: 3, color: Colors.blue),
        ],
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //spacing: 30,
          children: [
            FloatingActionButton(
              onPressed: () {
                _getDeviceInfo();
              },
              heroTag: null,
              child: Icon(Icons.perm_device_information),
            ),
            FloatingActionButton(
              onPressed: () {
                _getEncode(_textCtrl.value.text);
              },
              heroTag: null,
              child: Icon(Icons.lock),
            ),
            FloatingActionButton(
              onPressed: () {
                _getDecode(_encodeText);
              },
              heroTag: null,
              child: Icon(Icons.lock_open),
            ),
            FloatingActionButton(
              onPressed: () {
                _showDialog();
              },
              heroTag: null,
              child: Icon(Icons.message),
            ),
          ],
        ),
    );
  }

  Future<void> _getDeviceInfo() async {
    String deviceInfo;

    try {
      final String result = await platform1.invokeMethod('getDeviceInfo');
      deviceInfo = result;
    } on PlatformException catch (e) {
      deviceInfo = "Failed to get Device info : ${e.message}";
    }

    setState(() {
      _deviceInfo = deviceInfo;
    });
  }

  Future<void> _getEncode(String text) async {
    String encodeText;

    try {
      final String result = await platform2.invokeMethod('getEncode', text);
      encodeText = result;
    } on PlatformException catch (e) {
      encodeText = "Failed to get receive info : ${e.message}";
    }

    setState(() {
      _encodeText = encodeText;
    });
  }

  Future<void> _getDecode(String text) async {
    String decodeText;

    try {
      final String result = await platform2.invokeMethod('getDecode', text);
      decodeText = result;
    } on PlatformException catch (e) {
      decodeText = "Failed to get receive info : ${e.message}";
    }

    setState(() {
      _decodeText = decodeText;
    });
  }

  Future<void> _showDialog() async {
    try {
      await platform3.invokeMethod('showDialog');
    } on PlatformException catch (e) {
      print('${e.message}');
    }
  }
}
