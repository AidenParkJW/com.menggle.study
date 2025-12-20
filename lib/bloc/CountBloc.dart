import "dart:async";

class CountBloc {
  int _count = 0;
  final StreamController<int> _countController = StreamController<int>();
  Stream<int> get countStream => _countController.stream;

  CountEventBloc countEventBloc = CountEventBloc();

  CountBloc() {
    countEventBloc._countEventController.stream.listen((event) {
      switch (event) {
        case CountEvent.EVENT_PLUS:
          _count++;
          break;

        case CountEvent.EVENT_MINUS:
          _count--;
          break;
      }
      _countController.sink.add(_count);
    });
  }

  dispose() {
    _countController.close();
    countEventBloc.dispose();
  }
}

class CountEventBloc {
  final StreamController<CountEvent> _countEventController = StreamController<CountEvent>();

  Sink<CountEvent> get countEventSink => _countEventController.sink;

  dispose() {
    _countEventController.close();
  }
}

enum CountEvent {EVENT_PLUS, EVENT_MINUS}