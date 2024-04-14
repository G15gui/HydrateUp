import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'profileData.dart';
import 'texts.dart';

class Hydration extends StatefulWidget {
  const Hydration({super.key, this.title = 'Hydration'});
  final String title;
  @override
  State<Hydration> createState() => _Hydration();
}

class _Hydration extends State<Hydration> {
  TextEditingController weightController = TextEditingController();
  String result = "";

  @override
  void initState() {
    super.initState();

    if (Profile!.weight != null)
      weightController.text = Profile!.weight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              texts.hydrationText,
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
          children: [hydration(context)],
        ));
  }

  Widget hydration(BuildContext context) {
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Padding(
              padding: EdgeInsets.all(15),
              child: Text(texts.calculateText,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary))),
          Padding(
              padding: EdgeInsets.all(0),
              child: Text(texts.hydrationWhileExercisingText,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary))),
          SizedBox(
            width: 350,
            child: Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(texts.hydrationDescriptionText,
                    softWrap: true,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary))),
          ),
          Divider(
            height: 15,
            color: Colors.transparent,
          ),
          Text(texts.weightText,
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
                            controller: weightController,
                          ))),
                  Padding(
                    padding: EdgeInsets.only(left: 180, top: 15),
                    child: Text(
                      "kg",
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
                      var minValue = getWeight() * 8;
                      var maxValue = getWeight() * 11;
                      result = minValue.toStringAsFixed(0) +
                          " " +
                          texts.to +
                          " " +
                          maxValue.toStringAsFixed(0) +
                          " " +
                          texts.mlPerHour;
                      setState(() {});
                    }
                  },
                  child: Text(texts.calculateHydrationText))),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Text(texts.resultText,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          Padding(
              padding: EdgeInsets.all(5),
              child: SizedBox(
                  width: 240,
                  height: 65,
                  child: Card(
                      elevation: 3,
                      child: Center(
                          child: Text(
                        result,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15),
                      ))))),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
        ]));
  }

  double getWeight() {
    return double.parse(weightController.text);
  }

  bool CheckFields() {
    double? weight = double.tryParse(weightController.text);
    if (weight == null) return false;

    return true;
  }
}
