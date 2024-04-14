import 'package:flutter/material.dart';

import 'createGoalPage.dart';
import 'progressPanelPage.dart';
import 'goalsData.dart';
import 'editAlarmsPage.dart';
import 'setAlarms.dart';
import 'texts.dart';

class EditGoals extends StatefulWidget {
  const EditGoals({super.key, this.title = "Edit Goals"});
  final String title;
  @override
  State<EditGoals> createState() => _EditGoals();
}

_EditGoals? SingletonEditGoals;

class _EditGoals extends State<EditGoals> {
  @override
  void initState() {
    super.initState();

    SingletonEditGoals = this;
  }

  String? initTimePickedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              texts.editGoalsText,
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(27.0),
            )
          ],
        ),
        body: Goals(context));
  }

  Widget Goals(BuildContext context) {
    Map<int, Widget> cardsGoals = Map();

    for (var goal in AllGoals.values) {
      cardsGoals.putIfAbsent(goal.id, () => cardGoal(goal, context));
    }
    cardsGoals.putIfAbsent(-1, () => addCardGoal());

    return Center(
      child: GridView.count(
          crossAxisCount: 2, children: cardsGoals.values.toList()),
    );
  }

  Widget cardGoal(Goal goal, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Card(
          elevation: 5.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(getIconData(goal.icon)),
                  label: Text(goal.name)),
              Divider(
                height: 5,
                color: Colors.transparent,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: goal.progress / goal.goal,
                    strokeWidth: 4,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primary),
                    strokeAlign: 7,
                  ),
                  Text(
                    goal.progress.toStringAsFixed(0),
                    style: goalTextStyle(),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              Divider(
                height: 15,
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResetButton(goal),
                  DeleteButton(goal),
                  Alarm(goal),
                ],
              ),
            ],
          )),
    );
  }

  Widget ResetButton(Goal goal) {
    return SizedBox(
        height: 28,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: IconButton.filledTonal(
              color: Theme.of(context).colorScheme.primary,
              icon: Icon(
                Icons.restart_alt,
                size: 15,
              ),
              onPressed: () {
                goal.UpdateProgress(0);

                setState(() {});

                if (SingletonProgressPanel != null) {
                  SingletonProgressPanel?.setState(() {});
                }
              },
              // icon: Icon(
              //   Icons.restart_alt,
              //   size: 15,
              // ),
              // label: Text("Reset")
            )));
  }

  Widget DeleteButton(Goal goal) {
    if (goal.id == 0) {
      return Text("");
    }
    return SizedBox(
      height: 28,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: IconButton.filledTonal(
            color: Theme.of(context).colorScheme.primary,
            icon: Icon(
              Icons.delete,
              size: 15,
            ),
            onPressed: () {
              SetAlarms.cancelAll();
              goal.Delete();
              setState(() {});
              if (SingletonProgressPanel != null) {
                SingletonProgressPanel?.setState(() {});
              }
            },
            // icon: Icon(
            //   Icons.delete,
            //   size: 15,
            // ),
            // label: Text("Delete")
          )),
    );
  }

  Widget Alarm(Goal goal) {
    return SizedBox(
        height: 28,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: IconButton.filledTonal(
              color: Theme.of(context).colorScheme.primary,
              icon: Icon(
                Icons.alarm,
                size: 15,
              ),
              onPressed: () {
                //
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAlarms(
                              goal: goal,
                            )));
                // setState(() {});
                // if (SingletonProgressPanel != null) {
                //   SingletonProgressPanel?.setState(() {});
                // }
              },
            )));
  }

  Widget addCardGoal() {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
            elevation: 5.0,
            child: TextButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateGoal()));
                },
                label: Text(""),
                icon: Icon(Icons.dashboard_customize, size: 50),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))))));
  }

  TextStyle goalTextStyle() {
    return TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
