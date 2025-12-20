import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CountProvider.dart';
import 'CountView.dart';

class ProviderMain extends StatelessWidget {
  const ProviderMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Pattern',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CountProvider()),
        ],
        child: const Home(),
      )
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    print('Widget : Home');

    //CountProvider _countProvider = Provider.of<CountProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Provider Pattern')),
      body: CountView(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            //onPressed: () => _countProvider.plus(),
            onPressed: () => context.read<CountProvider>().plus(),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            //onPressed: () => _countProvider.minus(),
            onPressed: () => context.read<CountProvider>().minus(),
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
