import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'editGoalsPage.dart';
import 'progressPanelPage.dart';
import 'goalsData.dart';
import 'texts.dart';

class CreateGoal extends StatefulWidget {
  const CreateGoal({super.key, this.title = "Create Goal"});
  final String title;
  @override
  State<CreateGoal> createState() => _CreateGoal();
}

class _CreateGoal extends State<CreateGoal> {
  TextEditingController nameController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  int currentMetrificationIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              texts.createGoalText,
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(27.0),
            )
          ],
        ),
        body: ListView(
          children: [createGoal(context)],
        ));
  }

  Widget createGoal(BuildContext context) {
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Divider(
            height: 15,
            color: Colors.transparent,
          ),
          Text(texts.nameText,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          SizedBox(
              width: 240,
              child: Card(
                  elevation: 3,
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z ]+$')),
                        ],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        controller: nameController,
                      )))),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Text(texts.measureText,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          Padding(
              padding: EdgeInsets.all(5),
              child: SizedBox(
                  width: 240,
                  // height: 65,
                  child: Card(
                      elevation: 3,
                      child: Center(child: valueListWheelScrollView())))),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Text(texts.goalText,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          SizedBox(
              width: 240,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Card(
                      elevation: 3,
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.,]')),
                            ],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            controller: goalController,
                          ))),
                  Padding(
                    padding: EdgeInsets.only(left: 180, top: 15),
                    child: Text(
                      MeasurementList[currentMetrificationIndex],
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              )),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Padding(
              padding: EdgeInsets.all(5),
              child: ElevatedButton(
                  onPressed: () {
                    if (CheckFields()) {
                      createNewGoal(nameController.text, getGoal(),
                              currentMetrificationIndex)
                          .then((success) {
                        if (success) {
                          if (SingletonEditGoals != null) {
                            SingletonEditGoals?.setState(() {});
                          }

                          if (SingletonProgressPanel != null) {
                            SingletonProgressPanel?.setState(() {});
                          }

                          Navigator.pop(context, false);
                        }
                      });
                    }
                  },
                  child: Text(texts.createText)))
        ]));
  }

  Widget valueListWheelScrollView() {
    List<Widget> valueList = List.empty(growable: true);
    for (var element in MeasurementList) {
      valueList.add(setValueList(element));
    }
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: 85,
          height: 60,
          child: ListWheelScrollView(
              onSelectedItemChanged: (value) =>
                  {currentMetrificationIndex = value, setState(() {})},
              overAndUnderCenterOpacity: .25,
              itemExtent: 20,
              children: valueList))
    ]);
  }

  Widget setValueList(String value) {
    return Center(child: Text(value, style: valueTextStyle()));
  }

  TextStyle valueTextStyle() {
    return TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  double getGoal() {
    return double.parse(goalController.text);
  }

  bool CheckFields() {
    double? goal = double.tryParse(goalController.text);
    if (goal == null) return false;
    return true;
  }
}
