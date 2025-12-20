import "package:flutter/material.dart";
import "package:study/bloc/CountBloc.dart";
import "package:study/bloc/CountView.dart";

class BlocMain extends StatefulWidget {
  const BlocMain({super.key});

  @override
  State<BlocMain> createState() => _BlockMain();
}

class _BlockMain extends State<BlocMain> {
  late final CountBloc countBloc;

  @override
  void initState() {
    super.initState();
    countBloc = CountBloc();
  }

  @override
  void dispose() {
    super.dispose();
    countBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc Pattern')),
      body: CountView(countBloc: countBloc),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            onPressed: () {
              countBloc.countEventBloc.countEventSink.add(
                CountEvent.EVENT_PLUS,
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              countBloc.countEventBloc.countEventSink.add(
                CountEvent.EVENT_MINUS,
              );
            },
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
