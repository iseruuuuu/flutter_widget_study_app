import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void reBuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('MyHomePageStateをビルド');
    return MyHomePageInheritedWidget(
      data: this,
      counter: counter,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              WidgetA(),
              WidgetB(),
              WidgetC(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePageInheritedWidget extends InheritedWidget {
  const MyHomePageInheritedWidget({
    Key? key,
    required Widget child,
    required this.data,
    required this.counter,
  }) : super(key: key, child: child);

  final MyHomePageState data;
  final int counter;

  static MyHomePageState of(BuildContext context, {bool listen = true}) {
    if (listen) {
      //TODO いつでもビルドしなおす
      return (context.dependOnInheritedWidgetOfExactType<MyHomePageInheritedWidget>())!.data;
    } else {
      //TODO リビルドしないよ
      return (context.getElementForInheritedWidgetOfExactType<MyHomePageInheritedWidget>()!.widget as MyHomePageInheritedWidget).data;
    }
  }

  @override
  bool updateShouldNotify(MyHomePageInheritedWidget oldWidet) {
    //TODO 今送られたCounterと前のCounterが違う時だけTrueにする。
    //TODO 数が増えていないと状態管理しないようにしている。
    return counter != oldWidet.counter;
  }
}

class WidgetA extends StatelessWidget {
  const WidgetA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('WidgetAをビルド');
    return const Text(
      'You have pushed the button this many times:',
    );
  }
}

class WidgetB extends StatelessWidget {
  const WidgetB({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyHomePageState state = MyHomePageInheritedWidget.of(context);
    print('WidgetBをビルド');
    return Text(
      '${state.counter}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class WidgetC extends StatelessWidget {
  const WidgetC({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('WidgetCをビルド');
    final MyHomePageState state =
    MyHomePageInheritedWidget.of(context, listen: false);
    return ElevatedButton(
      onPressed: () {
        // state.incrementCounter();
        //TODO Widgetはリビルドされていない。
        state.reBuild();
      },
      child: const Text('カウント'),
    );
  }
}

class WidgetD extends StatelessWidget {
  const WidgetD({
    Key? key,
    required this.counter,
  }) : super(key: key);

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//TODO InheritedWidget について（メリット）

//・状態管理をlistenを使うことで状態管理するかを決められる。
//・それぞれの子Widgetたちに状態やロジックを渡すときにコンストラクターを用いてやるやり方でない
//・Stateに直接InheritedWidgetを用いてアクセスできる。→状態やロジックにアクセスできる。

//TODO デメリット

//・コード量が多くなる
//・状態の処理・処理・見た目が一つに書かれている

