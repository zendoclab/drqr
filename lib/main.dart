import 'dart:ui';

import 'package:drqr/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:side_sheet/side_sheet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _fruits = <String>[
    "apple",
    "banana",
    "strawberry",
    "가나다라마바사아바사아자차카자차자차",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "ban1ana",
    "str2awberry",
    "oatm3eal",
    "oatm7eal",
    "ban81ana",
    "str2a43wberry",
    "oatm32eal"
  ];
  final _gridViewKey = GlobalKey();
  final _scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();



  @override
  void initState() {
    super.initState();
  }


  bool _checkVal = false;

  @override
  Widget build(BuildContext context) {
    final generatedChildren = List.generate(
        _fruits.length + 1,
        (index) => index == _fruits.length
            ? Container(
                key: Key("$index"),
                height: (((index + 1) % 3) + 1) * 100.0,
                alignment: const Alignment(0, 0),
                color: Theme.of(context).colorScheme.outlineVariant,
                child: InkResponse(
                    onTap: ()  {
                      SideSheet.right(
                          sheetColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          sheetBorderRadius: 16.0,
                          barrierDismissible: true,
                          barrierLabel: '링크 입력',
                          width: MediaQuery.of(context).size.width * 0.98,
                          body: StatefulBuilder(builder: (BuildContext context, StateSetter myState) => Form(
                              key: formKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context,
                                            'Data returns from right side sheet')),
                                    Divider(),
                                    const SizedBox(height: 8.0),
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode.always,
                                      controller: _controller,
                                      onSaved: (val) {
                                        setState(() {});
                                      },
                                      validator: (val) {
                                        if (val!.isEmpty ||
                                            val.length > 20 ||
                                            RegExp(r'[^\u3131-\u3163\uAC00-\uD7A3a-zA-Z0-9,.?!@#$%&* \s]')
                                                .hasMatch(val)) {
                                          return '특수문자는 제한됩니다';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        if (FocusScope.of(context).hasFocus) {
                                          setState(() {});
                                        }
                                      },
                                      maxLength: 20,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: '링크 제목',
                                        helperText: null,
                                        labelText: null,
                                      ),
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode.always,
                                      controller: _controller2,
                                      onSaved: (val) {
                                        setState(() {});
                                      },
                                      validator: (val) {
                                        if (val!.isEmpty ||
                                            !RegExp(r'^(.*?)((?:https?:\/\/|www\.)[^\s/$.?#].[^\s]*)')
                                                .hasMatch(val)) {
                                          return '올바른 웹주소를 입력하세요';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        if (FocusScope.of(context).hasFocus) {
                                          setState(() {});
                                        }
                                      },
                                      maxLength: 200,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: '웹 주소',
                                        helperText: null,
                                        labelText: null,
                                      ),
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 16.0),
                                    Row(
                                      children: [
                                        const SizedBox(width: 4.0),
                                        Checkbox(
                                            value: _checkVal,
                                            onChanged: (val) {
                                              myState(() {
                                                _checkVal = val!;
                                              });
                                            }),
                                        Text("링크공개"),
                                        Tooltip(
                                          message: '공개된 링크는 검색, 공유, 고객편의를 위해 사용될 예정입니다',
                                          child: Align(alignment: Alignment.topRight, child: Icon(Icons.info_outline, size: 16.0)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState?.save();
                                            Navigator.pop(context, '');
                                            _controller.clear();
                                            _controller2.clear();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text('링크 입력됨'),
                                                // action: SnackBarAction(label: '확인', onPressed: () {}),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('입력'),
                                      ),
                                    )
                                  ]))),
                          context: context);
                    },
                    child: Icon(Icons.add)))
            : Container(
                key: Key("$index"),
                height: (((index + 1) % 3) + 1) * 100.0,
                alignment: const Alignment(0, 0),
                color: Theme.of(context).colorScheme.outlineVariant,
                child: InkResponse(
                    onTap: () {
                      SideSheet.right(
                          sheetColor: Theme.of(context).colorScheme.surface,
                          sheetBorderRadius: 16.0,
                          barrierDismissible: true,
                          barrierLabel: _fruits[index],
                          width: MediaQuery.of(context).size.width * 0.98,
                          body: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.pop(context,
                                  'Data returns from right side sheet')),
                          context: context);
                    },
                    child: Text(_fruits.elementAt(index),
                        style: TextStyle(fontSize: 14, height: 0.8)))));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title,
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
      body: ReorderableBuilder(
        lockedIndices: [_fruits.length],
        scrollController: _scrollController,
        longPressDelay: Duration(milliseconds: 300),
        enableScrollingWhileDragging: true,
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
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 2,
                  maxCrossAxisExtent: 100));
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Container _buildBottomSheet(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.9,
    width: double.infinity,
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: ListView(
      children: <Widget>[
        const ListTile(title: Text('Bottom sheet')),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(Icons.attach_money),
            labelText: 'Enter an integer',
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save and close'),
            onPressed: () => Navigator.pop(context),
          ),
        )
      ],
    ),
  );
}
