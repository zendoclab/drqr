import 'dart:ui';

import 'package:drqr/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:responsive_grid/responsive_grid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse, PointerDeviceKind.stylus, PointerDeviceKind.unknown
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'drqr',
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: '닥터큐알'),
      builder: (BuildContext context, Widget? child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  final _fruits = <String>["apple", "banana", "strawberry", "가나다라마바사아자차카타파", "ban1ana", "str2awberry", "oatm3eal", "oatm7eal", "ban81ana", "str2a43wberry", "oatm32eal"];
  final double _iconSize = 90;
  late List<Widget> _tiles;
  final _gridViewKey = GlobalKey();
  final _scrollController = ScrollController();

  Widget _buildStaggeredGridList() {
    return ResponsiveStaggeredGridList(
      //crossAxisAlignment: CrossAxisAlignment.end,
        desiredItemWidth: 100,
        minSpacing: 10,
        children: _fruits.map((i) {
          return Container(
            height: ((i.indexOf(i) % 3) + 1) * 100.0,
            alignment: const Alignment(0, 0),
            color: Colors.cyan,
            child: Text(i.toString()),
          );
        }).toList());
  }

  @override
  void initState() {
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
    });
  }

  final data = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {

    final generatedChildren = List.generate(
      _fruits.length,
          (index) => Container(
        key: Key(_fruits.elementAt(index)),
            height: (((index+1) % 3) + 1) * 100.0,
            alignment: const Alignment(0, 0),
            color: Colors.cyan,
        child: Wrap(children: [Text(
          _fruits.elementAt(index), style: TextStyle(fontSize: 14, height: 0.8)
        )]),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title,
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
      body: ReorderableBuilder(
        longPressDelay: Duration(milliseconds: 0),
        enableScrollingWhileDragging: false,
      enableDraggable: true,
      children: generatedChildren,
      onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
        for (final orderUpdateEntity in orderUpdateEntities) {
          final fruit = _fruits.removeAt(orderUpdateEntity.oldIndex);
          _fruits.insert(orderUpdateEntity.newIndex, fruit);
        }
      },
      builder: (children) {
        return GridView(
          key: _gridViewKey,
          controller: _scrollController,
          padding: EdgeInsets.all(8.0),
          children: children,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing : 4.0,
            crossAxisSpacing : 4.0,
            childAspectRatio : 2.5, maxCrossAxisExtent: MediaQuery.of(context).size.width/4)
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
