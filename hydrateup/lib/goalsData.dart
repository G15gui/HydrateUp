import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'profileData.dart';
import 'setAlarms.dart';
import 'texts.dart';

Map<int, Goal> AllGoals = Map();

class alarmData {
  String? name;
  int id;
  int hours = 0;
  int min = 0;
  bool enable = true;
  int periodOffset = 0;
  alarmData(
      {required this.id,
      required this.hours,
      required this.min,
      required this.periodOffset,
      this.enable = true});

  alarmData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String?,
        hours = json['hours'] as int,
        min = json['min'] as int,
        periodOffset = json['periodOffset'] as int,
        enable = json['enable'] as bool;

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'hours': hours,
        'min': min,
        'periodOffset': periodOffset,
        'enable': enable,
      };
}

class AllGoalsToJson {
  String goals;

  AllGoalsToJson.fromJson(Map<int, dynamic> json)
      : goals = json['goals'] as String;

  Map<String, dynamic> toJson() => {
        'goals': jsonEncode(goals),
      };
}

List<alarmData> getAlarms(List<dynamic> json) {
  List<alarmData> temp = List.empty(growable: true);

  for (var a in json) {
    temp.add(alarmData(
        id: a['id'],
        hours: a['hours'],
        min: a['min'],
        periodOffset: a['periodOffset'],
        enable: a['enable']));
  }

  temp.sort((a, b) => compararPorHoraMinuto(a, b));

  return temp;
}

int compararPorHoraMinuto(alarmData a, alarmData b) {
  int diferencaHora = a.hours - b.hours;
  if (diferencaHora != 0) {
    return diferencaHora;
  } else {
    int diferencaMinuto = a.min - b.min;
    return diferencaMinuto;
  }
}
// class fakeGoal {
//   int id;
//   String name;
//   double goal;
//   double progress;
//   int metrificationIndex;

//   fakeGoal({
//     required this.id,
//     required this.name,
//     required this.goal,
//     required this.progress,
//     required this.metrificationIndex,
//   });
// }

class Goal {
  int id;
  String _name;
  String get name {
    if (id == 0) {
      return texts.waterText;
    }
    return _name;
  }

  set name(String value) {
    _name = value;
  }

  double goal;
  double progress = 0;
  int metrificationIndex;
  SelectIcon icon;
  bool enable = true;
  List<alarmData> alarms = List.empty(growable: true);

  Goal.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        _name = json['name'] as String,
        goal = json['goal'] as double,
        progress = json['progress'] as double,
        metrificationIndex = json['metrificationIndex'] as int,
        icon = SelectIcon.battery_charging_full,
        enable = true,
        alarms = getAlarms(json['alarms'] as List<dynamic>);

  Goal.fromJsonOffAlarms(Map<String, dynamic> json)
      : id = json['id'] as int,
        _name = json['name'] as String,
        goal = json['goal'] as double,
        progress = json['progress'] as double,
        metrificationIndex = json['metrificationIndex'] as int,
        icon = SelectIcon.battery_charging_full,
        enable = true;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'goal': goal,
        'progress': progress,
        'metrificationIndex': metrificationIndex,
        'alarms': alarms,
      };
  Map<String, dynamic> toJsonNoAlarms() => {
        'id': id,
        'name': name,
        'goal': goal,
        'progress': progress,
        'metrificationIndex': metrificationIndex,
      };
  Goal(
      {required this.id,
      required String name,
      required this.goal,
      this.metrificationIndex = 0,
      this.icon = SelectIcon.battery_charging_full,
      this.enable = true,
      this.progress = 0})
      : _name = name;

  void UpdateProgress(double progress) {
    {
      this.progress = progress;
      saveGoals();
    }
  }

  void UpdateProgressNoSave(double progress) {
    {
      this.progress = progress;
    }
  }

  void UpdateGoal(double goal) {
    {
      this.goal = goal;
      saveGoals();
    }
  }

  void Delete() {
    {
      AllGoals.remove(this.id);
      saveGoals();
    }
  }

  void AddAlarm(alarmData alarm) {
    this.alarms.add(alarm);
    this.alarms.sort((a, b) => compararPorHoraMinuto(a, b));
    //saveGoals();
  }

  void DeleteAlarm(alarmData alarm) {
    {
      this.alarms.remove(alarm);
      this.alarms.sort((a, b) => compararPorHoraMinuto(a, b));
      saveGoals();
    }
  }
}

enum SelectIcon {
  battery_charging_full,
}

SelectIcon getIcon(String icon) {
  switch (icon) {
    case ("SelectIcon.battery_charging_full"):
      return SelectIcon.battery_charging_full;
  }
  return SelectIcon.battery_charging_full;
}

IconData getIconData(SelectIcon icon) {
  switch (icon) {
    case (SelectIcon.battery_charging_full):
      return Icons.battery_charging_full;
  }
  // return Icons.battery_charging_full;
}

Future<bool> saveGoals() async {
  // final List<String> setGoals = List.empty(growable: true);

  // for (var goal in AllGoals.values) {
  //   List<String> convert = [
  //     goal.id.toString(),
  //     "/",
  //     goal.name,
  //     "/",
  //     goal.goal.toString(),
  //     "/",
  //     goal.progress.toString(),
  //     "/",
  //     goal.metrificationIndex.toString(),
  //     "/",
  //     goal.icon.toString()
  //   ];

  //   setGoals.add(convert.join());

  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setStringList("goals", setGoals);
  // }
  Map<String, dynamic> map = new Map.identity();
  Map<String, dynamic> mapc = new Map.identity();

  for (var goal in AllGoals.values) {
    // print(jsonEncode(goal.toJson()));
    map.putIfAbsent(goal.id.toString(), (() => goal.toJson()));
    mapc.putIfAbsent(goal.id.toString(), (() => goal.toJsonNoAlarms()));
    // print(map);
  }
  // print((jsonEncode(map)));
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("goalsJson", (jsonEncode(map)));

  sendMapContext(mapc);

  SetAlarms.All();
  return true;
}

void sendMap() async {
  Map<String, dynamic> map = new Map.identity();
  for (var goal in AllGoals.values) {
    // print(jsonEncode(goal.toJson()));
    // fakeGoal fg = fakeGoal(
    //   id: goal.id,
    //   name: goal.name,
    //   goal: goal.goal,
    //   progress: goal.progress,
    //   metrificationIndex: goal.metrificationIndex,
    // );
    await map.putIfAbsent(goal.id.toString(), (() => goal.toJsonNoAlarms()));

    //print(map);
  }
  sendMapContext(map);
}

void sendMapContext(map) {
  Map<String, dynamic> mapContext = new Map.identity();
  mapContext.putIfAbsent('goals', (() => map));
  sendContext(mapContext);
}

Future<Goal?> loadGoals() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await Future.doWhile(() async {
    return ProfileSuccess == false;
  });

  final String? goalsJson = prefs.getString('goalsJson');
  if (goalsJson != null) {
    Map<String, dynamic> jsonToGoals = jsonDecode(goalsJson);
    for (var g in jsonToGoals.values) {
      if (g['alarms'] == null) {
        var newGoal = Goal.fromJsonOffAlarms(g);
        addGoal(newGoal);
      } else {
        var newGoal = Goal.fromJson(g);
        addGoal(newGoal);
      }
    }
  } else {
    final List<String>? goals = prefs.getStringList('goals');
    if (goals == null) {
      if (ProfileSuccess) await createGoal(newGoalDefault());
      print("if ProfileSuccess");
    } else {
      print("else ProfileSuccess");
      for (var goal in goals) {
        var getGoal = goal.split("/");
        var newGoal = Goal(
            id: int.parse(getGoal[0]),
            name: getGoal[1],
            goal: double.parse(getGoal[2]),
            progress: double.parse(getGoal[3]),
            metrificationIndex: int.parse(getGoal[4]).toInt(),
            icon: getIcon(getGoal[5]));
        addGoal(newGoal);
      }
    }
  }
  sendMap();
  return getGoalByID(-1);
}

Future<bool> createNewGoal(String name, double goal, int metrificationIndex) {
  var newGoal = Goal(
      id: AllGoals.length,
      name: name,
      goal: goal,
      metrificationIndex: metrificationIndex,
      icon: SelectIcon.battery_charging_full);
  addGoal(newGoal);
  return saveGoals();
}

Future<bool> createGoal(Goal goal) {
  addGoal(goal);
  return saveGoals();
}

Goal? getGoalByID(int id) {
  if (AllGoals.containsKey(id)) {
    for (var goal in AllGoals.values) {
      if (goal.id == id) return goal;
    }
  }
  if (AllGoals.length > 0) {
    return AllGoals.values.first;
  }

  return null;
}

Goal newGoalDefault() {
  double? weight = Profile!.weight;

  if (weight != null) {
    return Goal(
        id: 0,
        name: "Water",
        goal: (35 * weight).toDouble(),
        metrificationIndex: 4,
        icon: SelectIcon.battery_charging_full);
  }

  return Goal(
      id: 0,
      name: "Water",
      goal: 2000,
      metrificationIndex: 4,
      icon: SelectIcon.battery_charging_full);
}

void addGoal(Goal goal) {
  AllGoals.putIfAbsent(goal.id, (() => goal));
}

void updateGoal() {
  double? weight = Profile!.weight;

  if (weight != null) {
    double goal = (35 * weight).toDouble();
    getGoalByID(0)?.UpdateGoal(goal);
  }
}
