import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/bloc_main.dart';
import 'firebase/ads_main.dart';
import 'firebase/memo_main.dart';
import 'firebase/noti_main.dart';
import 'native/native_main.dart';
import 'provider/provider_main.dart';
import 'sub/animal.dart';
import 'sub/book_search.dart';
import 'sub/first_page.dart';
import 'sub/large_file.dart';
import 'sub/second_page.dart';
import 'todo_db/todoDB01.dart';
import 'todo_txt/todoTxt01.dart';
import 'todo_txt/todoTxt02.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  
  // Flutter 앱의 메인 실행 흐름(runApp()) 이전에 네이티브 플랫폼 기능을 사용하기 위한 다리(바인딩)를 놓는 역할을 담당
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 서비스(Realtime Database, Firestore, Authentication, Storage) 연동을 위한 초기화
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.pink),
        //useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Study App'),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: 'Flutter Study App'),
        "/todoTxt01": (context) => TodoTxt01(),
        "/todoTxt02": (context) => TodoTxt02(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final List<Animal> _animalList = List.empty(growable: true);
  bool _isVisibleIntro = true;

  @override
  void initState() {
    super.initState();

    // vsync: this를 사용하기 위해서 SingleTickerProviderStateMixin 상속
    _tabCtrl = TabController(length: 12, vsync: this);

    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        print("이전 index, ${_tabCtrl.previousIndex}");
        print("이후 index, ${_tabCtrl.index}");
      }
    });

    _animalList.add(
      Animal(
        imagePath: 'images/bee.png',
        animalName: '벌',
        kind: '곤충',
        flyExists: true,
      ),
    );
    _animalList.add(
      Animal(
        imagePath: 'images/cat.png',
        animalName: '고양이',
        kind: '포유류',
        flyExists: false,
      ),
    );
    _animalList.add(
      Animal(
        imagePath: 'images/cow.png',
        animalName: '젖소',
        kind: '포유류',
        flyExists: false,
      ),
    );
    _animalList.add(
      Animal(
        imagePath: 'images/dog.png',
        animalName: '강아지',
        kind: '포유류',
        flyExists: false,
      ),
    );
    _animalList.add(
      Animal(
        imagePath: 'images/fox.png',
        animalName: '여우',
        kind: '포유류',
        flyExists: false,
      ),
    );
    _animalList.add(
      Animal(
        imagePath: 'images/monkey.png',
        animalName: '원숭이',
        kind: '영장류',
        flyExists: false,
      ),
    );
    _animalList.add(
      Animal(
        imagePath: 'images/pig.png',
        animalName: '돼지',
        kind: '포유류',
        flyExists: false,
      ),
    );
    _animalList.add(
      Animal(
        imagePath: 'images/wolf.png',
        animalName: '늑대',
        kind: '포유류',
        flyExists: false,
      ),
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabCtrl,
            children: [
              FirstPage(animalList: _animalList),
              SecondPage(animalList: _animalList),
              BookSearch(),
              LargeFile(),
              TodoTxt01(),
              BlocMain(),
              ProviderMain(),
              TodoDB01(),
              NativeMain(),
              AdsMain(),
              MemoMain(),
              NotiMain(),
            ],
          ),

          Visibility(
            visible: _isVisibleIntro,
            child: Positioned(
              child: FutureBuilder(
                future: loadIntro(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text("loading...");
                    case ConnectionState.waiting:
                      return Text("loading...");
                    case ConnectionState.active:
                      return Text("loading...");
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return Center(child: snapshot.data as Widget);
                      }
                  }
                  return Text("Error");
                },
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        color: Colors.black,
        child: TabBar(
          labelColor: const Color.fromARGB(255, 122, 53, 53),
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.pets)),
            Tab(icon: Icon(Icons.add_photo_alternate_outlined)),
            Tab(icon: Icon(Icons.menu_book)),
            Tab(icon: Icon(Icons.save_alt)),
            Tab(icon: Icon(Icons.edit_note)),
            Tab(text: 'Bloc'),
            Tab(text: 'Provider'),
            Tab(icon: Icon(Icons.format_list_bulleted_add)),
            Tab(icon: Icon(Icons.memory)),
            Tab(icon: Icon(Icons.ads_click)),
            Tab(icon: Icon(Icons.cloud_sync)),
            Tab(icon: Icon(Icons.notifications)),
          ],
          indicatorColor: Colors.blue,
          dividerColor: Colors.black,
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
        ),
      ),
    );
  }

  Future<Widget> loadIntro() async {
    //BuildContext? context = navigatorKey.currentContext;
    var dir = await getApplicationDocumentsDirectory();
    String filePath = '${dir.path}/myimage.jpg';

    File file = File(filePath);
    bool isExist = await file.exists();
    await FileImage(file).evict();

    if (isExist) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isVisibleIntro = false;
          });
        },
        child: Image.file(file, height: 200, width: 200, fit: BoxFit.contain),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            _tabCtrl.index = 3;
            _isVisibleIntro = false;
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: Text('이미지 다운로드 하기...'),
      );
    }
  }
}
