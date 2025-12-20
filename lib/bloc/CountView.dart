import "package:flutter/material.dart";
import "package:study/bloc/CountBloc.dart";

class CountView extends StatelessWidget {
  final CountBloc countBloc;

  const CountView({super.key, required this.countBloc});

  @override
  Widget build(BuildContext context) {
    print("CountView Build!!");

    return Center(
      child: StreamBuilder(
        stream: countBloc.countStream,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data.toString(),
              style: const TextStyle(fontSize: 80),
            );
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
