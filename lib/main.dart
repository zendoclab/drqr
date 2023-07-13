import 'dart:js_interop';
import 'dart:math';
import 'dart:ui';

import 'package:drqr/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

late Box linktoqrcode;
late FirebaseFirestore db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  db = FirebaseFirestore.instance;
  try {
    await FirebaseAuth.instance.signInAnonymously();
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        break;
      default:
    }
  }
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
      home: const MyHomePage(title: 'drqr'),
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
  List? links;
  final _gridViewKey = GlobalKey();
  final _scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  final formKey3 = GlobalKey<FormState>();
  final _controller5 = TextEditingController();

  String? shareText;

  @override
  void initState() {
    links = linktoqrcode.get('links');
    _fruits.addAll(links?.map((e) => e['subject']) ?? []);
    super.initState();
    }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  var publiclyLinks = 0;

  bool _checkVal = false;
  bool _checkVal2 = false;
  bool _edit = false;

  String _getRanDate() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random.secure();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return "${DateTime.now().toIso8601String().replaceAll(RegExp(r'[^0-9]'), '')}:${getRandomString(17)}";
  }

  @override
  Widget build(BuildContext context) {
    final locale = View.of(context).platformDispatcher.locale;

    final generatedChildren = List.generate(
        _fruits.length + 2,
            (index) => index == _fruits.length + 1
            ? Container(
            key: Key("$index"),
            height: (((index + 1) % 3) + 1) * 100.0,
            alignment: const Alignment(0, 0),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: InkResponse(
                onTap: () async {

                  _checkVal = false;
                  _controller.clear();
                  _controller2
                      .clear();

                  await SideSheet.right(
                      sheetColor:
                      Theme.of(context).colorScheme.surfaceVariant,
                      sheetBorderRadius: 16.0,
                      barrierDismissible: true,
                      barrierLabel: 'Add Link',
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
                                                  icon: const Icon(
                                                      Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        'links to qrcode');
                                                  }),
                                              const Divider(),

                                              Card(

                                                  shape: RoundedRectangleBorder(  //모서리를 둥글게 하기 위해 사용
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  elevation: 4.0, //그림자 깊이
                                                  child: Column(
                                                      children: [
                                              const SizedBox(height: 8.0),
                                              const SizedBox(height: 8.0),
                                              TextFormField(
                                                keyboardType: TextInputType.text,
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
                                                    return locale
                                                        .languageCode ==
                                                        'ko'
                                                        ? '링크 제목을 입력하세요 (특수문자 제한)'
                                                        : 'Enter a link title (special characters restricted)';
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
                                                  hintText: 'Link title',
                                                  helperText: null,
                                                  labelText: null,
                                                ),
                                                maxLines: 1,
                                              ),
                                              const SizedBox(height: 16.0),
                                              TextFormField(
                                                keyboardType: TextInputType.url,
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
                                                    return locale.languageCode ==
                                                        'ko'
                                                        ? '올바른 웹페이지 주소를 입력 하세요 (https://)'
                                                        : 'Enter a valid web page address (https://)';
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
                                                  hintText:
                                                  'Web page address',
                                                  helperText: null,
                                                  labelText: null,
                                                ),
                                                maxLines: 1,
                                              ),
                                              const SizedBox(height: 16.0),
                                              Row(mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
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
                                                      locale.languageCode ==
                                                          'ko'
                                                          ? const Text("공개")
                                                          : const Text(
                                                          "Publicly"),
                                                      Tooltip(
                                                        message: locale
                                                            .languageCode ==
                                                            'ko'
                                                            ? '공개된 링크는 검색, 공유, 고객편의를 위해 사용될 예정입니다'
                                                            : 'Publicly available links will be used for search, sharing, and customer convenience',
                                                        child: const Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Icon(
                                                                Icons
                                                                    .info_outline,
                                                                size: 16.0)),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          formKey.currentState
                                                              ?.save();

                                                          var _id =
                                                          _getRanDate();

                                                          if (_checkVal) {
                                                            db
                                                                .collection(
                                                                "drqr")
                                                                .add({
                                                              "subject":
                                                              _controller
                                                                  .text,
                                                              "web":
                                                              _controller2
                                                                  .text,
                                                              "_id": _id
                                                            }).then((documentSnapshot) {
                                                              var snapId =
                                                                  documentSnapshot
                                                                      .id;
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
                                                                    _checkVal,
                                                                    "date": _id,
                                                                    "snap": snapId
                                                                  }
                                                                ];
                                                                linktoqrcode.put(
                                                                    'links', links);
                                                              } else {
                                                                links?.add({
                                                                  "subject":
                                                                  _controller
                                                                      .text,
                                                                  "web":
                                                                  _controller2
                                                                      .text,
                                                                  "open": _checkVal,
                                                                  "date": _id,
                                                                  "snap": snapId
                                                                });
                                                                linktoqrcode.put(
                                                                    'links', links);
                                                              }
                                                            });
                                                          }
                                                          else {
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
                                                                  _checkVal,
                                                                  "date": _id,
                                                                  "snap": "null"
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
                                                                "open": _checkVal,
                                                                "date": _id,
                                                                "snap": "null"
                                                              });
                                                            }
                                                          }

                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              duration:
                                                              const Duration(
                                                                  seconds:
                                                                  1),
                                                              content: locale.languageCode ==
                                                                  'ko'
                                                                  ? const Text(
                                                                  '링크 입력됨')
                                                                  : const Text(
                                                                  "Link submitted"),
                                                              // action: SnackBarAction(label: '확인', onPressed: () {}),
                                                            ),
                                                          );
                                                          setState(() {
                                                            _fruits.add(
                                                                _controller
                                                                    .text);
                                                            linktoqrcode.put(
                                                                'links', links);
                                                            links = linktoqrcode
                                                                .get('links');
                                                          });
                                                          Navigator.pop(
                                                              context, '');
                                                        }
                                                      },
                                                      child:
                                                      locale
                                                          .languageCode ==
                                                          'ko'
                                                          ? const Text("링크 추가")
                                                          : const Text(
                                                          "Add Link"),
                                                    ),
                                                  )
                                                ],
                                              ),])),

                                              const SizedBox(height: 16.0),
                                              const Divider(),
                                              const SizedBox(height: 8.0),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0,0.0,2.0,0.0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          autovalidateMode:
                                          AutovalidateMode.always,
                                          controller: _controller5,
                                          onSaved: (val) {
                                            setState(() {});
                                          },
                                          validator: (val) {
                                            if (val!.isEmpty ||
                                                val.length > 20 ||
                                                RegExp(r'[^\u3131-\u3163\uAC00-\uD7A3a-zA-Z0-9,.?!@#$%&* \s]')
                                                    .hasMatch(val)) {
                                              return locale
                                                  .languageCode ==
                                                  'ko'
                                                  ? '주제어를 입력하세요 (특수문자 제한)'
                                                  : 'Enter key words (special characters restricted)';
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
                                            hintText: 'Keywords',
                                            helperText: null,
                                            labelText: null,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(6.0,0.0,8.0,0.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        SideSheet.right(
                                            sheetColor: Theme.of(context).colorScheme.surface,
                                            sheetBorderRadius: 16.0,
                                            barrierDismissible: true,
                                            width: MediaQuery.of(context).size.width * 0.96,
                                            body: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                          StateSetter myState2) =>
                                                          Text("리스트")
                                                  ),
                                                ],
                                              ),
                                            ),
                                            context: context);
                                      },
                                      child:
                                      locale.languageCode ==
                                          'ko'
                                          ? const Text('링크 검색')
                                          : const Text(
                                          'Search Link'),
                                    ),
                                  )
                                ],
                              ),]))),
                          ],
                        ),
                      ),
                      context: context);
                },
                child: const Icon(Icons.add)))
            : index == _fruits.length
            ? Container(
            key: Key("$index"),
            height: (((index + 1) % 3) + 1) * 100.0,
            alignment: const Alignment(0, 0),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: InkResponse(
                onTap: () {
                  shareText = links?.map((e) => "${e['subject']} ${e['web']}\n").join();
                  if (shareText!.length>0) {
                    Share.share(subject: 'drqr', shareText! + "${linktoqrcode.get("links").toString()}");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 1),
                      content: locale.languageCode == 'ko'
                          ? const Text('공유할 링크목록이 없습니다')
                          : const Text("No list of links to share"),
                    ));
                  }
                },
                child: const Icon(Icons.share)))
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
                  _edit = false;

                  await SideSheet.right(
                      sheetColor: Theme.of(context).colorScheme.surface,
                      sheetBorderRadius: 16.0,
                      barrierDismissible: true,
                      width: MediaQuery.of(context).size.width * 0.98,
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            StatefulBuilder(
                                builder:
                                    (BuildContext context,
                                    StateSetter myState2) =>
                                    Form(
                                        key: formKey2,
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              IconButton(
                                                  icon: const Icon(
                                                      Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context,
                                                        'links to qrcode');
                                                  }),
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
                                                      height:
                                                      8.0),
                                                  Align(
                                                    alignment:
                                                    Alignment
                                                        .center,
                                                    child: Text(
                                                        links?[index]['subject'],
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold)),
                                                  ),
                                                  const SizedBox(
                                                      height:
                                                      8.0),
                                                  Align(
                                                      alignment:
                                                      Alignment
                                                          .center,
                                                      child:
                                                      PrettyQr(
                                                        typeNumber:
                                                        null,
                                                        size:
                                                        300,
                                                        data: links?[index]
                                                        [
                                                        'web'],
                                                        errorCorrectLevel:
                                                        QrErrorCorrectLevel.M,
                                                        roundEdges:
                                                        true,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                  height: 16.0),
                                              ExpansionTile(
                                                title: locale
                                                    .languageCode ==
                                                    'ko'
                                                    ? const Text(
                                                    "링크 수정")
                                                    : const Text(
                                                    "Modify Link"),
                                                onExpansionChanged:
                                                    (val) {
                                                  myState2(() {
                                                    _edit = val;
                                                    if(val) {
                                                      _controller3.text = links?[index]['subject'];
                                                      _controller4.text = links?[index]['web'];
                                                      _checkVal2 = links?[index]['open'];
                                                    }
                                                  });
                                                },
                                                children: [
                                                  TextFormField(
                                                    keyboardType: TextInputType.text,
                                                    autovalidateMode:
                                                    AutovalidateMode
                                                        .always,
                                                    controller:
                                                    _controller3,
                                                    onSaved: (val) {
                                                      setState(
                                                              () {});
                                                    },
                                                    validator:
                                                        (val) {
                                                      if (val!.isEmpty ||
                                                          val.length >
                                                              20 ||
                                                          RegExp(r'[^\u3131-\u3163\uAC00-\uD7A3a-zA-Z0-9,.?!@#$%&* \s]')
                                                              .hasMatch(
                                                              val)) {
                                                        return locale.languageCode ==
                                                            'ko'
                                                            ? '링크 제목을 입력하세요 (특수문자 제한)'
                                                            : 'Enter a link title (special characters restricted)';
                                                      }
                                                      return null;
                                                    },
                                                    onTap: () {
                                                      if (FocusScope.of(
                                                          context)
                                                          .hasFocus) {
                                                        setState(
                                                                () {});
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
                                                      hintText:
                                                      'Link title',
                                                      helperText:
                                                      null,
                                                      labelText:
                                                      null,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(
                                                      height: 16.0),
                                                  TextFormField(
                                                    keyboardType: TextInputType.url,
                                                    autovalidateMode:
                                                    AutovalidateMode
                                                        .always,
                                                    controller:
                                                    _controller4,
                                                    onSaved: (val) {
                                                      setState(
                                                              () {});
                                                    },
                                                    validator:
                                                        (val) {
                                                      if (val!.isEmpty ||
                                                          !RegExp(r'^(.*?)((?:https?:\/\/|www\.)[^\s/$.?#].[^\s]*)')
                                                              .hasMatch(
                                                              val)) {
                                                        return locale.languageCode ==
                                                            'ko'
                                                            ? '올바른 웹페이지 주소를 입력 하세요 (https://)'
                                                            : 'Enter a valid web page address (https://)';
                                                      }
                                                      return null;
                                                    },
                                                    onTap: () {
                                                      if (FocusScope.of(
                                                          context)
                                                          .hasFocus) {
                                                        setState(
                                                                () {});
                                                      }
                                                    },
                                                    maxLength: 200,
                                                    decoration:
                                                    const InputDecoration(
                                                      border:
                                                      OutlineInputBorder(),
                                                      hintText:
                                                      'Web page address',
                                                      helperText:
                                                      null,
                                                      labelText:
                                                      null,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(
                                                      height: 16.0),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                          width:
                                                          4.0),
                                                      Checkbox(
                                                          value:
                                                          _checkVal2,
                                                          onChanged:
                                                              (val) {
                                                            myState2(
                                                                    () {
                                                                  _checkVal2 =
                                                                  val!;
                                                                });
                                                          }),
                                                      locale.languageCode ==
                                                          'ko'
                                                          ? const Text(
                                                          "공개")
                                                          : const Text(
                                                          "Publicly"),
                                                      Tooltip(
                                                        message: locale.languageCode ==
                                                            'ko'
                                                            ? '공개된 링크는 검색, 공유, 고객편의를 위해 사용될 예정입니다'
                                                            : 'Publicly available links will be used for search, sharing, and customer convenience',
                                                        child: const Align(
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
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        child:
                                                        ElevatedButton(
                                                          onPressed:
                                                              () {
                                                            if (formKey2
                                                                .currentState!
                                                                .validate()) {
                                                              formKey2
                                                                  .currentState
                                                                  ?.save();

                                                              var _id =
                                                              _getRanDate();

                                                              db
                                                                  .collection("drqr")
                                                                  .doc(links?[index]["snap"])
                                                                  .delete();

                                                              links?.removeAt(
                                                                  index);

                                                              ScaffoldMessenger.of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  duration: const Duration(seconds: 1),
                                                                  content: locale.languageCode == 'ko' ? const Text('링크 삭제됨') : const Text('Link deleted'),
                                                                  // action: SnackBarAction(label: '확인', onPressed: () {}),
                                                                ),
                                                              );
                                                              setState(
                                                                      () {
                                                                    _fruits.removeAt(index);
                                                                    linktoqrcode.put(
                                                                        'links',
                                                                        links);
                                                                    links =
                                                                        linktoqrcode.get('links');
                                                                  });
                                                            }
                                                            Navigator.pop(
                                                                context,
                                                                '');
                                                          },
                                                          child: locale.languageCode ==
                                                              'ko'
                                                              ? const Text(
                                                              '삭제')
                                                              : const Text(
                                                              'Delete'),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        child:
                                                        ElevatedButton(
                                                          onPressed:
                                                              () {
                                                            if (formKey2
                                                                .currentState!
                                                                .validate()) {
                                                              formKey2
                                                                  .currentState
                                                                  ?.save();

                                                              var _id =
                                                              _getRanDate();

                                                              if (_checkVal2) {
                                                                if(links?[index]['snap']=="null") {
                                                                  db.collection("drqr").add({
                                                                    "subject": _controller3.text,
                                                                    "web": _controller4.text,
                                                                    "_id": _id
                                                                  }).then((documentSnapshot) {
                                                                    var snapId = documentSnapshot.id;
                                                                    links?[index] =
                                                                    {
                                                                      "subject": _controller3.text,
                                                                      "web": _controller4.text,
                                                                      "open": _checkVal2,
                                                                      "date": _id,
                                                                      "snap": snapId
                                                                    };
                                                                  });
                                                                }
                                                                else {
                                                                  db.collection("drqr").doc(links?[index]["snap"]).set({
                                                                    "subject": _controller3.text,
                                                                    "web": _controller4.text,
                                                                    "_id": links?[index]['date']
                                                                  }).then((value) => links?[index] =
                                                                  {
                                                                    "subject": _controller3.text,
                                                                    "web": _controller4.text,
                                                                    "open": _checkVal2,
                                                                    "date": links?[index]['date'],
                                                                    "snap": links?[index]['snap']
                                                                  });
                                                                }
                                                              }
                                                              else {
                                                                if(links?[index]['snap']=="null") {
                                                                }
                                                                else {
                                                                  db.collection("drqr").doc(links?[index]["snap"]).delete();
                                                                }
                                                                links?[index] = {
                                                                  "subject": _controller3.text,
                                                                  "web": _controller4.text,
                                                                  "open": _checkVal2,
                                                                  "date": links?[index]['date'],
                                                                  "snap": links?[index]['snap']
                                                                };
                                                              }

                                                              ScaffoldMessenger.of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  duration: const Duration(seconds: 1),
                                                                  content: locale.languageCode == 'ko' ? const Text('링크 수정됨') : const Text('Link modified'),
                                                                  // action: SnackBarAction(label: '확인', onPressed: () {}),
                                                                ),
                                                              );
                                                              setState(
                                                                      () {
                                                                    _fruits[index] =
                                                                        _controller3.text;

                                                                    linktoqrcode.put(
                                                                        'links',
                                                                        links);
                                                                    links =
                                                                        linktoqrcode.get('links');
                                                                  });

                                                              Navigator.pop(
                                                                  context,
                                                                  '');
                                                            }
                                                          },
                                                          child: locale.languageCode ==
                                                              'ko'
                                                              ? const Text(
                                                              '수정')
                                                              : const Text(
                                                              'Edit'),
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
                },
                child: Text(
                    _fruits.elementAt(index),
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 0.8)))));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: Row(
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface)),
            const SizedBox(
              width: 2.0,
            ),
            Tooltip(
              message: locale.languageCode == 'ko'
                  ? '고객에게 QR코드로 웹페이지의 정보를 전달하세요\n링크목록은 웹브라우저에 영구적으로 저장됩니다\n링크박스를 길게 누르면 목록순서를 바꿀 수 있습니다'
                  : 'Give customers information from webpage with QR Codes\nList of links is permanently stored in the web browser\nYou can change the order of list by long-pressing the link box',
              child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.info_outline,
                      size: 16.0,
                      color: Theme.of(context).colorScheme.onInverseSurface)),
            ),
          ],
        ),
      ),
      body: ReorderableBuilder(
        lockedIndices: [_fruits.length + 1, _fruits.length],
        scrollController: _scrollController,
        longPressDelay: const Duration(milliseconds: 300),
        enableScrollingWhileDragging: true,
        enableDraggable: true,
        children: generatedChildren,
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {

            final link = links?.removeAt(orderUpdateEntity.oldIndex);
            links?.insert(orderUpdateEntity.newIndex, link);
            linktoqrcode.put('links', links);
            final fruit = _fruits.removeAt(orderUpdateEntity.oldIndex);
            _fruits.insert(orderUpdateEntity.newIndex, fruit);
          }
          setState(() {
            links = linktoqrcode.get('links');});
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