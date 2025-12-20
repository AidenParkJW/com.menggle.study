import 'package:flutter/material.dart';

import 'animal.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.animalList});
  final List<Animal> animalList;
  
  @override
  State<FirstPage> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, position) {
            return GestureDetector(
              child: Card(
                child: Row(
                  children: [
                    Image.asset(
                      widget.animalList[position].imagePath!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    Text(widget.animalList[position].animalName!),
                  ],
                ),
              ),
              onTap: () {
                AlertDialog dialog = AlertDialog(
                  content: Text(
                    '이 동물은 ${widget.animalList[position].kind}입니다.',
                    style: TextStyle(fontSize: 30.0),
                  ),
                );

                showDialog(context: context, builder: (BuildContext context) {
                  return dialog;
                });
              },
            );
          },
          itemCount: widget.animalList.length,
        ),
      ),
    );
  }
}
