import 'package:HydrateUp/goalsData.dart';
import 'package:HydrateUp/setAlarms.dart';
import 'package:flutter/material.dart';

import 'app_localizations.dart';
import 'texts.dart';

class EditAlarms extends StatefulWidget {
  EditAlarms({super.key, this.title = "Edit Alarms", required this.goal});
  final String title;
  final Goal goal;
  @override
  State<EditAlarms> createState() => _Alarms();

  // print(goal.toString());
}

class _Alarms extends State<EditAlarms> {
  String? initTimePickedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              texts.editAlarmsText,
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(27.0),
            )
          ],
        ),
        body: Alarm());
  }

  Widget Alarm() {
    return Container(
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
        // constraints: const BoxConstraints.expand(
        //   width: 610,
        //   height: 510,
        // ),
        color: Theme.of(context).colorScheme.background,
        child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 111, bottom: 55),
                  child: Text(
                    texts.alarmsTexts,
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  )),
              Center(child: AlarmsList()),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 111),
                  child: Card(
                      child: IconButton(
                    onPressed: () async {
                      showTimePicker(
                        context: this.context,
                        initialTime: TimeOfDay.now(),
                      ).then((initTimePicked) {
                        // createHighlightOverlay();
                        if (initTimePicked != null) {
                          initTimePickedText =
                              "${initTimePicked.hour.toString()}:${initTimePicked.minute.toString()}";

                          int count = 10000;
                          var newAlarm = alarmData(
                              id: count,
                              hours: initTimePicked.hour,
                              min: initTimePicked.minute,
                              periodOffset: initTimePicked.periodOffset);

                          this.widget.goal.AddAlarm(newAlarm);
                          ReplaceAlarmsIDs();
                          //
                          print(newAlarm.id);

                          saveGoals();
                        }
                        setState(() {});
                      });
                    },
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icon(
                      Icons.add_alarm,
                    ),
                  )),
                ),
              )
            ]));
  }

  void ReplaceAlarmsIDs() {
    int count = 10000;
    for (var g in AllGoals.values) {
      // ignore: unused_local_variable
      for (var a in g.alarms) {
        count++;
        a.id = count;
      }
    }
  } // var g = alarmData(hours: 11, min: 22);

  Widget AlarmsList() {
    List<Widget> list = List.empty(growable: true);
    for (var a in this.widget.goal.alarms) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).locale.languageCode == "pt"
                ? "${a.hours}".padLeft(2, '0') +
                    ":" +
                    "${a.min}".padLeft(2, '0')
                : ("${a.hours >= 13 ? a.hours - a.periodOffset : a.hours == 0 ? 12 : a.hours}")
                        .padLeft(2, '0') +
                    ":" +
                    "${a.min.toString().padLeft(2, '0')} ${a.periodOffset == 12 ? "ᴾᴹ" : "ᴬᴹ"}",
            style: TextStyle(
                fontSize: 33,
                color: a.enable
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.secondary),
          ),
          Padding(
              padding: EdgeInsets.only(left: 3),
              child: SizedBox(
                // height: 33,
                // width: 33,
                child: IconButton(
                  onPressed: () {
                    SetAlarms.cancelAll();
                    // this.widget.goal.alarms.remove(g);
                    this.widget.goal.DeleteAlarm(a);
                    saveGoals();
                    setState(() {});
                  },
                  icon: Icon(Icons.delete),
                  color: a.enable
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  iconSize: 22,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(left: 3),
              child: SizedBox(
                width: 77,
                // height: 11,
                child: Slider(
                  activeColor: a.enable
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.secondary,
                  thumbColor: a.enable
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.secondary,
                  value: a.enable ? 1 : 0,
                  min: 0,
                  max: 1,
                  // divisions: 1,
                  // label: _currentSliderValue.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      a.enable = value >= .5 ? true : false;
                      print(a.enable);
                    });
                  },
                  onChangeEnd: (value) {
                    saveGoals();
                  },
                ),
              )),
        ],
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget DeleteButton() {
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
              // goal.Delete();
              // setState(() {});
              // if (SingletonProgressPanel != null) {
              //   SingletonProgressPanel?.setState(() {});
              // }
            },
            // icon: Icon(
            //   Icons.delete,
            //   size: 15,
            // ),
            // label: Text("Delete")
          )),
    );
  }
}
