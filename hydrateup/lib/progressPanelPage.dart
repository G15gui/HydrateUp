import 'package:flutter/material.dart';
import 'dart:async';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';

import 'editGoalsPage.dart';
import 'goalsData.dart';
import 'profileData.dart';
import 'editProfilePage.dart';
import 'setAlarms.dart';
import 'texts.dart';

Goal? currentGoal;
int CurrentGoalID = -2;
int MeasurementIndex = 0;

double animationTime = 200;
int animationDelay = (1000.0 ~/ animationTime).toInt();
int ripplesPerAnimation = 0;
Color ripplesColor = Colors.white;
RippleAnimation ripple = offRippleAnimation();
Key rippleAnimationKey = Key("rippleAnimation");

List<String> MeasurementList = ["cal", "kcal", "g", "kg", "ml", "l"];
List<double> IncrementValueList = [.2, .15, .1, .05, .01];
int currentIncrementIndex = 0;
int Increment = 0;

double opacity = 1;
int AnimatedOpacityTime = 150;

double get currentIncrementValue {
  return ((currentGoal!.goal * IncrementValueList[currentIncrementIndex]) +
      (currentGoal!.goal * (Increment * .1)));
}

class ProgressPanel extends StatefulWidget {
  const ProgressPanel({super.key, this.title = 'ProgressPanel'});
  final String title;
  @override
  State<ProgressPanel> createState() => _ProgressPanel();
}

_ProgressPanel? SingletonProgressPanel;

class _ProgressPanel extends State<ProgressPanel> {
  @override
  void initState() {
    super.initState();

    SingletonProgressPanel = this;

    loadProfile().then((success) {
      if (!success) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditProfile()));
      } else {
        loadGoals().then((value) {
          if (value != null) {
            CurrentGoalID = value.id;
            setState(() {});
            SetAlarms.All();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ripple.color == Colors.white) {
      ripplesColor = Theme.of(context).colorScheme.inversePrimary;
    }
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: setCurrentGoal(GetGoal(CurrentGoalID))));
  }

  Goal? GetGoal(int id) {
    if (id == -2) {
      return null;
    }
    var Goal = getGoalByID(id);
    CurrentGoalID = Goal!.id;
    currentGoal = Goal;
    return Goal;
  }

  List<Widget> setCurrentGoal(Goal? goal) {
    if (goal == null) {
      return [];
    }
    return [
      Padding(
        padding: const EdgeInsets.all(5),
        child: AnimatedOpacity(
            opacity: opacity,
            duration: Duration(milliseconds: AnimatedOpacityTime),
            child: Text(
              goal.name,
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.inversePrimary),
              textAlign: TextAlign.center,
            )),
      ),
      Divider(
        height: 5,
        color: Colors.transparent,
      ),
      AnimatedOpacity(
          opacity: opacity,
          duration: Duration(milliseconds: AnimatedOpacityTime),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: goal.progress / goal.goal,
                strokeWidth: 12,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.inversePrimary),
                strokeAlign: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Divider(
                        height: 20,
                        color: Colors.transparent,
                      ),
                      Text(
                        goal.progress.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 60,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                          (goal.progress / goal.goal * 100).toStringAsFixed(0) +
                              " %",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )),
                      Text(
                          "(" +
                              goal.goal.toString() +
                              " " +
                              MeasurementList[goal.metrificationIndex] +
                              ")",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ))
                    ],
                  ),
                ],
              ),
              ripple
            ],
          )),
      Divider(
        height: 5,
        color: Colors.transparent,
      ),
      Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                  onPressed: () {
                    removeInMetric(currentIncrementValue);
                  },
                  child: const Icon(Icons.remove)),
            ),
            Center(
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: Column(children: [
                            valueListWheelScrollView(),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                      child: Icon(
                                        Icons.remove_circle,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        if (Increment >= 1) Increment--;
                                        setState(() {});
                                      }),
                                  TextButton(
                                    child: Icon(
                                      Icons.add_circle,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      if (Increment <= 7) Increment++;
                                      setState(() {});
                                    },
                                  )
                                ]),
                            Text(
                              ((100 *
                                              IncrementValueList[
                                                  currentIncrementIndex]) +
                                          (100 * (Increment * .1)))
                                      .toStringAsFixed(0) +
                                  " %",
                              style: valueTextStyle(),
                            )
                          ])),
                    ))),
            Padding(
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                    onPressed: () {
                      addInMetric(currentIncrementValue);
                    },
                    child: const Icon(Icons.add)))
          ]),
      SizedBox(
          height: 35,
          width: 320,
          child: ListView(
              children: goalButtonList(), scrollDirection: Axis.horizontal)),
      Padding(
          padding: const EdgeInsets.all(0),
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditGoals()));
            },
            icon: Icon(Icons.edit),
            label: Text(texts.editGoalsText),
          ))
    ];
  }

  Widget goalButton(Goal goal) {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: ElevatedButton(
            onPressed: () => {
                  if (CurrentGoalID != goal.id)
                    {
                      opacity = 0,
                      setState(() {}),
                      Timer(Duration(milliseconds: AnimatedOpacityTime * 2),
                          () {
                        CurrentGoalID = goal.id;
                        currentGoal = goal;
                        opacity = 1;
                        setState(() {});
                      }),
                    }
                },
            child: Text(goal.name)));
  }

  List<Widget> goalButtonList() {
    Map<int, Widget> cardsGoals = Map();

    for (var goal in AllGoals.values) {
      cardsGoals.putIfAbsent(goal.id, () => goalButton(goal));
    }
    return cardsGoals.values.toList();
  }

  void removeInMetric(double value) async {
    if (currentGoal!.progress == 0) return;

    var newProgress = 0.0;

    if (currentGoal!.progress > value)
      newProgress = currentGoal!.progress - value;

    while (currentGoal!.progress > newProgress) {
      var result = value / animationTime;
      currentGoal!.progress -= result;
      setState(() {});
      await Future.delayed(Duration(milliseconds: (1000 ~/ 200).toInt()));
    }
    currentGoal!.UpdateProgress(newProgress);

    setState(() {});
  }

  void addInMetric(double value) async {
    var newProgress = currentGoal!.progress + value;
    while (currentGoal!.progress < newProgress) {
      var result = value / animationTime;
      currentGoal!.progress += result;
      setState(() {});
      await Future.delayed(Duration(milliseconds: animationDelay));
    }
    currentGoal!.UpdateProgress(newProgress);
    setState(() {});

    await Future.delayed(Duration(milliseconds: animationDelay));

    ripplesPerAnimation = 5;
    ripple = rippleAnimation();
    setState(() {});

    await Future.delayed(ripple.duration);

    ripple = offRippleAnimation();
    setState(() {});
  }

  // Widget setMeasurementList(Widget widget, Color color) {
  //   return Container(color: color, child: widget);
  // }

  Widget setMeasurementList(String text) {
    return Center(child: Text(text, style: measurementTextStyle()));
  }

  Widget measurementListWheelScrollView() {
    List<Widget> list = List.empty(growable: true);

    for (var element in MeasurementList) {
      list.add(setMeasurementList(element));
    }

    return Column(
        // padding: EdgeInsets.all(0),

        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
              width: 50,
              height: 75,
              child: Padding(
                padding: EdgeInsets.all(0),
                child: ListWheelScrollView(
                    onSelectedItemChanged: (value) =>
                        {MeasurementIndex = value, setState(() {})},
                    overAndUnderCenterOpacity: .25,
                    itemExtent: 20,
                    children: list),
              ))
        ]);
  }

  TextStyle measurementTextStyle() {
    return TextStyle(
      // fontSize: 30,
      color: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  Widget setValueList(double value) {
    return Center(
        child: Text(
            (((currentGoal!.goal * value) +
                        (currentGoal!.goal * (Increment * .1)))
                    .toStringAsFixed(0) +
                " " +
                MeasurementList[currentGoal!.metrificationIndex]),
            style: valueTextStyle()));
  }

  Widget valueListWheelScrollView() {
    List<Widget> valueList = List.empty(growable: true);
    for (var element in IncrementValueList) {
      valueList.add(setValueList(element));
    }
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: 85,
          height: 60,
          child: ListWheelScrollView(
              onSelectedItemChanged: (value) =>
                  {currentIncrementIndex = value, setState(() {})},
              overAndUnderCenterOpacity: .25,
              itemExtent: 20,
              children: valueList))
    ]);
  }

  TextStyle valueTextStyle() {
    return TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.inversePrimary,
    );
  }
}

RippleAnimation rippleAnimation() {
  return RippleAnimation(
      key: rippleAnimationKey,
      repeat: true,
      size: Size.fromRadius(1),
      minRadius: 90,
      ripplesCount: ripplesPerAnimation,
      color: ripplesColor,
      delay: Duration(seconds: 0),
      duration: Duration(seconds: 2),
      child: Text(""));
}

RippleAnimation offRippleAnimation() {
  return RippleAnimation(
      repeat: false,
      size: Size.fromRadius(1),
      minRadius: 0,
      ripplesCount: ripplesPerAnimation,
      color: ripplesColor,
      delay: Duration(seconds: 0),
      duration: Duration(seconds: 1),
      child: Text(""));
}
