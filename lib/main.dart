import 'dart:js_interop';
import 'dart:ui';

import 'package:drqr/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

late Box? linktoqrcode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  linktoqrcode = await Hive.openBox('linktoqrcode');
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
  List<String> _fruits = [];
  late List? links;
  final _gridViewKey = GlobalKey();
  final _scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (linktoqrcode.isNull) {
      links = null;
    } else {
      links = linktoqrcode?.get('links');
      _fruits.addAll(links?.map((e) => e['subject']) ?? []);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  bool _checkVal = false;
  bool _checkVal2 = false;
  bool _edit = false;

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
                    onTap: () async {
                      await SideSheet.right(
                          sheetColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          sheetBorderRadius: 16.0,
                          barrierDismissible: true,
                          barrierLabel: '링크 입력',
                          width: MediaQuery.of(context).size.width * 0.98,
                          body: SingleChildScrollView(
                            child: Column(
                              children: [
                                StatefulBuilder(
                                    builder: (BuildContext context,
                                            StateSetter myState) =>
                                        Form(
                                            key: formKey,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                      icon: const Icon(Icons.close),
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Data returns from right side sheet')),
                                                  const Divider(),
                                                  const SizedBox(height: 8.0),
                                                  const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text("링크 추가",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                  const SizedBox(height: 8.0),
                                                  TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode.always,
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
                                                      if (FocusScope.of(context)
                                                          .hasFocus) {
                                                        setState(() {});
                                                      }
                                                    },
                                                    maxLength: 20,
                                                    maxLengthEnforcement:
                                                        MaxLengthEnforcement
                                                            .enforced,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: '링크 제목',
                                                      helperText: null,
                                                      labelText: null,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode.always,
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
                                                      if (FocusScope.of(context)
                                                          .hasFocus) {
                                                        setState(() {});
                                                      }
                                                    },
                                                    maxLength: 200,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: '웹 주소',
                                                      helperText: null,
                                                      labelText: null,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                          width: 4.0),
                                                      Checkbox(
                                                          value: _checkVal,
                                                          onChanged: (val) {
                                                            myState(() {
                                                              _checkVal = val!;
                                                            });
                                                          }),
                                                      const Text("공개"),
                                                      const Tooltip(
                                                        message:
                                                            '공개된 링크는 검색, 공유, 고객편의를 위해 사용될 예정입니다',
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Icon(
                                                                Icons
                                                                    .info_outline,
                                                                size: 16.0)),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          formKey.currentState
                                                              ?.save();
                                                          if (links.isNull) {
                                                            links = [
                                                              {
                                                                "subject":
                                                                    _controller
                                                                        .text,
                                                                "web":
                                                                    _controller2
                                                                        .text,
                                                                "open":
                                                                    _checkVal
                                                              }
                                                            ];
                                                          } else {
                                                            links?.add({
                                                              "subject":
                                                                  _controller
                                                                      .text,
                                                              "web":
                                                                  _controller2
                                                                      .text,
                                                              "open": _checkVal
                                                            });
                                                          }
                                                          linktoqrcode?.put(
                                                              'links', links);
                                                          setState(() {
                                                            _fruits.add(
                                                                _controller
                                                                    .text);
                                                            _checkVal = false;
                                                            _controller.clear();
                                                            _controller2
                                                                .clear();
                                                          });
                                                          Navigator.pop(
                                                              context, '');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              content: Text(
                                                                  '링크 입력됨'),
                                                              // action: SnackBarAction(label: '확인', onPressed: () {}),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: const Text('입력'),
                                                    ),
                                                  )
                                                ]))),
                              ],
                            ),
                          ),
                          context: context);
                      _checkVal = _checkVal2 = _edit = false;
                    },
                    child: const Icon(Icons.add)))
            : Container(
                key: Key("$index"),
                height: (((index + 1) % 3) + 1) * 100.0,
                alignment: const Alignment(0, 0),
                color: Theme.of(context).colorScheme.outlineVariant,
                child: InkResponse(
                    onTap: () async {
                      _controller3.text = links?[index]['subject'];
                      _controller4.text = links?[index]['web'];
                      _checkVal2 = links?[index]['open'];
                      await SideSheet.right(
                          sheetColor: Theme.of(context).colorScheme.surface,
                          sheetBorderRadius: 16.0,
                          barrierDismissible: true,
                          width: MediaQuery.of(context).size.width * 0.98,
                          body: SingleChildScrollView(
                            child: Column(
                              children: [
                                StatefulBuilder(
                                    builder: (BuildContext context,
                                            StateSetter myState2) =>
                                        Form(
                                            key: formKey2,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                      icon: const Icon(Icons.close),
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Data returns from right side sheet')),
                                                  const Divider(),
                                                  _edit
                                                      ? Container(
                                                          height: 0.0,
                                                        )
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                                height: 8.0),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  _controller3
                                                                      .text,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            const SizedBox(
                                                                height: 8.0),
                                                            Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: PrettyQr(
                                                                  typeNumber:
                                                                      null,
                                                                  size: 300,
                                                                  data: links?[
                                                                          index]
                                                                      ['web'],
                                                                  errorCorrectLevel:
                                                                      QrErrorCorrectLevel
                                                                          .M,
                                                                  roundEdges:
                                                                      true,
                                                                )),
                                                          ],
                                                        ),
                                                  const SizedBox(height: 16.0),
                                                  ExpansionTile(
                                                    title: const Text("링크 수정"),
                                                    onExpansionChanged: (val) {
                                                      myState2(() {
                                                        _edit = val;
                                                      });
                                                    },
                                                    children: [
                                                      TextFormField(
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .always,
                                                        controller:
                                                            _controller3,
                                                        onSaved: (val) {
                                                          setState(() {});
                                                        },
                                                        validator: (val) {
                                                          if (val!.isEmpty ||
                                                              val.length > 20 ||
                                                              RegExp(r'[^\u3131-\u3163\uAC00-\uD7A3a-zA-Z0-9,.?!@#$%&* \s]')
                                                                  .hasMatch(
                                                                      val)) {
                                                            return '특수문자는 제한됩니다';
                                                          }
                                                          return null;
                                                        },
                                                        onTap: () {
                                                          if (FocusScope.of(
                                                                  context)
                                                              .hasFocus) {
                                                            setState(() {});
                                                          }
                                                        },
                                                        maxLength: 20,
                                                        maxLengthEnforcement:
                                                            MaxLengthEnforcement
                                                                .enforced,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: '링크 제목',
                                                          helperText: null,
                                                          labelText: null,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                      const SizedBox(
                                                          height: 16.0),
                                                      TextFormField(
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .always,
                                                        controller:
                                                            _controller4,
                                                        onSaved: (val) {
                                                          setState(() {});
                                                        },
                                                        validator: (val) {
                                                          if (val!.isEmpty ||
                                                              !RegExp(r'^(.*?)((?:https?:\/\/|www\.)[^\s/$.?#].[^\s]*)')
                                                                  .hasMatch(
                                                                      val)) {
                                                            return '올바른 웹주소를 입력하세요';
                                                          }
                                                          return null;
                                                        },
                                                        onTap: () {
                                                          if (FocusScope.of(
                                                                  context)
                                                              .hasFocus) {
                                                            setState(() {});
                                                          }
                                                        },
                                                        maxLength: 200,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: '웹 주소',
                                                          helperText: null,
                                                          labelText: null,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                      const SizedBox(
                                                          height: 16.0),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Checkbox(
                                                              value: _checkVal2,
                                                              onChanged: (val) {
                                                                myState2(() {
                                                                  _checkVal2 =
                                                                      val!;
                                                                });
                                                              }),
                                                          const Text("공개"),
                                                          const Tooltip(
                                                            message:
                                                                '공개된 링크는 검색, 공유, 고객편의를 위해 사용될 예정입니다',
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size:
                                                                        16.0)),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                            Alignment.center,
                                                            child: ElevatedButton(
                                                              onPressed: () async {
                                                                if (formKey2
                                                                    .currentState!
                                                                    .validate()) {
                                                                  formKey2
                                                                      .currentState
                                                                      ?.save();
                                                                  links?.removeAt(index);

                                                                  linktoqrcode?.put(
                                                                      'links',
                                                                      links);

                                                                  setState(() {
                                                                    _fruits.removeAt(index);
                                                                    _checkVal2 =
                                                                    false;
                                                                    _controller3
                                                                        .clear();
                                                                    _controller4
                                                                        .clear();
                                                                  });

                                                                  Navigator.pop(
                                                                      context, '');
                                                                  ScaffoldMessenger
                                                                      .of(context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      duration:
                                                                      Duration(
                                                                          seconds:
                                                                          1),
                                                                      content: Text(
                                                                          '링크 삭제됨'),
                                                                      // action: SnackBarAction(label: '확인', onPressed: () {}),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child:
                                                              const Text('삭제'),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                Alignment.center,
                                                            child: ElevatedButton(
                                                              onPressed: () async {
                                                                if (formKey2
                                                                    .currentState!
                                                                    .validate()) {
                                                                  formKey2
                                                                      .currentState
                                                                      ?.save();
                                                                  links?[index] = {
                                                                    "subject":
                                                                        _controller3
                                                                            .text,
                                                                    "web":
                                                                        _controller4
                                                                            .text,
                                                                    "open":
                                                                        _checkVal2
                                                                  };
                                                                  linktoqrcode?.put(
                                                                      'links',
                                                                      links);
                                                                  setState(() {
                                                                    _fruits[index] =
                                                                        _controller3
                                                                            .text;
                                                                    _checkVal2 =
                                                                        false;
                                                                    _controller3
                                                                        .clear();
                                                                    _controller4
                                                                        .clear();
                                                                  });
                                                                  Navigator.pop(
                                                                      context, '');
                                                                  ScaffoldMessenger
                                                                          .of(context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      duration:
                                                                          Duration(
                                                                              seconds:
                                                                                  1),
                                                                      content: Text(
                                                                          '링크 수정됨'),
                                                                      // action: SnackBarAction(label: '확인', onPressed: () {}),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child:
                                                                  const Text('수정'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                    ],
                                                  ),
                                                ]))),
                              ],
                            ),
                          ),
                          context: context);
                      _checkVal = _checkVal2 = _edit = false;
                    },
                    child: Text(_fruits.elementAt(index),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 0.8)))));

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
        longPressDelay: const Duration(milliseconds: 300),
        enableScrollingWhileDragging: true,
        enableDraggable: true,
        children: generatedChildren,
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            final fruit = _fruits.removeAt(orderUpdateEntity.oldIndex);
            _fruits.insert(orderUpdateEntity.newIndex, fruit);
            final temp = links?[orderUpdateEntity.oldIndex];
            links?[orderUpdateEntity.oldIndex] =
                links?[orderUpdateEntity.newIndex];
            links?[orderUpdateEntity.newIndex] = temp;
            linktoqrcode?.put('links', links);
          }
        },
        builder: (children) {
          return GridView(
              key: _gridViewKey,
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 2,
                  maxCrossAxisExtent: 100),
              children: children);
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
