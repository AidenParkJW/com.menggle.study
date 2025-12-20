import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CountProvider.dart';

class CountView extends StatelessWidget {
  const CountView({super.key});

  @override
  Widget build(BuildContext context) {
    print("Widget : CountView");

    // return Center(
    //   child: Text(
    //     context.watch<CountProvider>().count.toString(),
    //     style: const TextStyle(fontSize: 80),
    //   ),
    // );

    return Center(
      child: Consumer<CountProvider>(
        builder: (context, provider, child) {
          return Text(
            provider.count.toString(),
            style: const TextStyle(fontSize: 80),
          );
        },
      ),
    );
  }
}
