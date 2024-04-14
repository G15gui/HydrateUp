//import 'dart:ui';
//import 'dart:io';
import 'dart:async';

import 'package:is_wear/is_wear.dart';
import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'menu.dart';
import 'goalsData.dart';
import 'texts.dart';
//import 'logoPage.dart';
import 'setAlarms.dart';
//import 'profileData.dart';
import 'progressPanelPage.dart';
import 'app_localizations.dart';

//import 'package:HydrateUp/goalsData.dart';

const themeColor = Color.fromARGB(255, 79, 230, 213);
late final bool isWear;

void main() {
  init();
}

void init() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await SetAlarms.setupLocalNotification();
  isWear = (await IsWear().check()) ?? false;

  // runApp(LogoPage());
  // await Future.delayed(Duration(seconds: 4));

  runApp(MyApp());

  Permission.notification.request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydrate Up',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // colorScheme: ColorScheme.dark(
        //   // dark colorscheme
        //   primary: themeColor,
        //   onBackground: Colors.black,
        //   onSurface: Colors.white,
        // ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: themeColor, outline: themeColor),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('pt', 'BR'),
        const Locale.fromSubtags(languageCode: 'en'),
      ],
      home: MyHomePage(title: 'Hydrate Up'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _watch = WatchConnectivity();

class _MyHomePageState extends State<MyHomePage> {
  //var _count = 0;

  var _supported = false;
  var _paired = false;
  var _reachable = false;
  var _context = <String, dynamic>{};
  var _receivedContexts = <Map<String, dynamic>>[];
  // final _log = <String>[];

  Timer? timer;
  @override
  void initState() {
    super.initState();

    _watch.messageStream.listen((data) => setState(() {
          // _log.add('Received message: $data');
          receivedUpdate();
        }));

    _watch.contextStream.listen((data) => setState(() {
          // _log.add('Received context: $data');
          receivedUpdate();
        }));

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() async {
    _supported = await _watch.isSupported;
    _paired = await _watch.isPaired;
    try {
      _reachable = await _watch.isReachable;
    } catch (e) {}
    try {
      _context = await _watch.applicationContext;
    } catch (e) {}
    receivedUpdate();
    setState(() {});
  }

  void receivedUpdate() async {
    try {
      _receivedContexts = await _watch.receivedApplicationContexts;
      if (!isWear) {
        for (var r in _receivedContexts) {
          if (r.containsKey('goal')) {
            Map<dynamic, dynamic> goalsResult = r['goal'];

            for (var g in goalsResult.values) {
              var goal = Goal(
                  id: g['id'],
                  name: g['name'],
                  goal: g['goal'],
                  progress: g['progress'],
                  metrificationIndex: g['metrificationIndex']);

              //print(goal.toJson().toString());
              var updateGoal = getGoalByID(goal.id);
              if (updateGoal != null) {
                updateGoal.UpdateProgress(goal.progress);
              }

              // if (wearGoals.containsKey(goal.id)) {
              //   var updateGoal = wearGoals[goal.id];
              //   if (updateGoal!.name == goal.name) {
              //     goal = updateGoal;
              //   }
              // }
            }
          }
        }
      }
    } catch (e) {}
  }

  //to listen
  // listenToNotifications() {
  //   print("listen");
  //   NotificationService.onClickNotification.stream.listen((event) {
  //     //
  //   });
  // }

  var wearost = false;
  Map<int, Goal> wearGoals = Map();
  @override
  Widget build(BuildContext context) {
    initTexts(context);

    final MediaQuerySize = MediaQuery.of(context).size;
    //final MediaQueryPixelRatio = MediaQuery.of(context).devicePixelRatio;

    if (isWear) {
      //if (wearost) {
      List<Widget> goalsView = List.empty(growable: true);
      for (var r in _receivedContexts) {
        if (r.containsKey('goals')) {
          Map<dynamic, dynamic> goalsResult = r['goals'];

          for (var g in goalsResult.values) {
            var goal = Goal(
                id: g['id'],
                name: g['name'],
                goal: g['goal'],
                progress: g['progress'],
                metrificationIndex: g['metrificationIndex']);

            if (wearGoals.containsKey(goal.id)) {
              var updateGoal = wearGoals[goal.id];
              if (updateGoal!.name == goal.name) {
                goal = updateGoal;
              }
            }

            var goalView = SafeArea(
              minimum: const EdgeInsets.only(top: 30, bottom: 30),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: goal.progress / goal.goal,
                    strokeWidth: 10,
                    backgroundColor: const Color.fromARGB(12, 255, 255, 255),
                    valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.inversePrimary),
                    strokeAlign: 15,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  Column(
                    children: [
                      Divider(
                        height: 12,
                        color: Colors.transparent,
                      ),
                      Text(goal.name.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                      Text(
                        goal.progress.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                          (goal.progress / goal.goal * 100).toStringAsFixed(0) +
                              " %",
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                      Text(
                          "(" +
                              goal.goal.toString() +
                              " " +
                              MeasurementList[goal.metrificationIndex] +
                              ")",
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                      Divider(
                        height: 12,
                        color: Colors.transparent,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          subButton(goal),
                          resetButton(goal),
                          addButton(goal),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // ripple
              // ],
              // )
            );
            goalsView.add(goalView);
          }
          break;
        }
      }
      wearGoals.clear();
      if (goalsView.isEmpty) {
        //if (true) {
        goalsView.clear();
        goalsView.add(Center(
          child: Text(
            "HydrateUp\n\nAguardando sicronização com o dispositivo...",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 7,
            ),
          ),
        ));
      }
      final home = Scaffold(
          body: Center(
        child: ListWheelScrollView(
            useMagnifier: false,
            magnification: MediaQuerySize.width > 200 ? 1.015 : .85,
            //onSelectedItemChanged: (value) => {
            //currentIncrementIndex = value, setState(() {})
            //},
            overAndUnderCenterOpacity: .25,
            itemExtent: 225,
            children: [
              // Center(
              //   child: Text(
              //     MediaQueryPixelRatio.toString(),
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 8),
              //   ),
              // ),

              ...goalsView,
              //Text('Context: $_context'),
              Center(
                child: TextButton(
                  onPressed: initPlatformState,
                  child: const Text('Refresh'),
                ),
              ),

              // Center(
              //   child: Text(
              //     'Received contexts: $_receivedContexts',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 8),
              //   ),
              // ),
            ]),
      ));
      /*
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...goalsView,

                  // Text('Supported: $_supported'),
                  // Text('Paired: $_paired'),
                  // Text('Reachable: $_reachable'),
                  // Text('Context: $_context'),
                  Text('Received contexts: $_receivedContexts'),
                  // TextButton(
                  //   onPressed: initPlatformState,
                  //   child: const Text('Refresh'),
                  // ),
                  const SizedBox(height: 8),
                  // const Text('Send'),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     TextButton(
                  //       onPressed: sendMessage,
                  //       child: const Text('Message'),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     TextButton(
                  //       onPressed: sendContext,
                  //       child: const Text('Context'),
                  //     ),
                  //   ],
                  // ),
                  // TextButton(
                  //   onPressed: toggleBackgroundMessaging,
                  //   child: Text(
                  //     '${timer == null ? 'Start' : 'Stop'} background messaging',
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  // const SizedBox(width: 16),
                  // TextButton(
                  //   onPressed: _watch.startWatchApp,
                  //   child: const Text('Start watch app'),
                  // ),
                  const SizedBox(width: 16),
                  // const Text('Log'),
                  // ..._log.reversed.map(Text.new),
                ],
              ),
            ),
          ),
        ),
      );
      */

      return MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.comfortable,
          colorScheme: const ColorScheme.dark(
            // dark colorscheme
            primary: themeColor,
            onBackground: Colors.black,
            onSurface: Colors.white,
          ),
          // colorScheme:
          //     ColorScheme.fromSeed(seedColor: themeColor, outline: themeColor),
          useMaterial3: true,
        ),
        home: home,
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: Theme.of(context).colorScheme.background),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(27.0),
          )
        ],
      ),
      drawer: Drawer(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        child: menuNavigationDrawer(context),
        // style: TextStyle(color: Theme.of(context).colorScheme.primary)
      ),
      body: ProgressPanel(),
    );
  }

  Widget resetButton(Goal goal) {
    return SizedBox(
      height: 22,
      child: IconButton.filled(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          foregroundColor: themeColor,
          backgroundColor: Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(),
        onPressed: () {
          goal.UpdateProgressNoSave(0);
          wearGoals.putIfAbsent(goal.id, () => goal);
          setState(() {
            sendMap(goal);
          });
        },
        icon: Icon(
          Icons.restart_alt,
          size: 11,
        ),
      ),
    );
  }

  Widget addButton(Goal goal) {
    return SizedBox(
      height: 22,
      child: IconButton.filled(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          foregroundColor: themeColor,
          backgroundColor: Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(),
        onPressed: () {
          var newProgress = goal.progress + (goal.goal * .1);
          goal.UpdateProgressNoSave(newProgress);
          wearGoals.putIfAbsent(goal.id, () => goal);
          setState(() {
            sendMap(goal);
          });
        },
        icon: Icon(
          Icons.add,
          size: 11,
        ),
      ),
    );
  }

  Widget subButton(Goal goal) {
    return SizedBox(
      height: 22,
      child: IconButton.filled(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          foregroundColor: themeColor,
          backgroundColor: Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(),
        onPressed: () {
          if (goal.progress == 0) return;

          var newProgress = 0.0;

          if (goal.progress > (goal.goal * .1))
            newProgress = goal.progress - (goal.goal * .1);

          goal.UpdateProgressNoSave(newProgress);
          wearGoals.putIfAbsent(goal.id, () => goal);
          setState(() {
            sendMap(goal);
          });
        },
        icon: Icon(
          Icons.remove,
          size: 11,
        ),
      ),
    );
  }

  void sendMap(Goal goal) {
    print(goal.toJson().toString());

    Map<String, dynamic> map = new Map.identity();
    // print(jsonEncode(goal.toJson()));
    map.putIfAbsent(goal.id.toString(), (() => goal.toJson()));
    // print(map);
    sendMapContext(map);
  }

  void sendMapContext(map) {
    Map<String, dynamic> mapContext = new Map.identity();
    mapContext.putIfAbsent('goal', (() => map));
    sendContext(mapContext);
  }

  void sendMessage(Map<String, dynamic> message) {
    //final message = {'data': 'Hello'};
    _watch.sendMessage(message);
    setState(() => {} //_log.add('Sent message: $message')
        );
  }

  void sendContext(Map<String, dynamic> context) {
    //_count++;
    //final context = {'data': _count};
    _watch.updateApplicationContext(context);
    setState(() => {} //_log.add('Sent context: $context')
        );
  }

  // void toggleBackgroundMessaging() {
  //   if (timer == null) {
  //     timer = Timer.periodic(const Duration(seconds: 1), (_) => sendMessage());
  //   } else {
  //     timer?.cancel();
  //     timer = null;
  //   }
  //   setState(() {});
  // }
}

void sendMessage(Map<String, dynamic> message) {
  //final message = {'data': 'Hello'};
  _watch.sendMessage(message);
  //setState(() => _log.add('Sent message: $message'));
}

void sendContext(Map<String, dynamic> context) {
  //_count++;
  //final context = {'data': _count};
  // try {
  _watch.updateApplicationContext(context);
  // } catch (e) {}
  //setState(() => _log.add('Sent context: $context'));
}
