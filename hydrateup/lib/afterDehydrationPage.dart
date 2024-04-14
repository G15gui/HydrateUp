import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'profileData.dart';
import 'texts.dart';

class Dehydration extends StatefulWidget {
  const Dehydration({super.key, this.title = 'Dehydration'});
  final String title;
  @override
  State<Dehydration> createState() => _Dehydration();
}

class _Dehydration extends State<Dehydration> {
  TextEditingController initialWeightController = TextEditingController();
  TextEditingController finalWeightController = TextEditingController();
  String result = "";
  String dehydration = "";
  String hydration = "";

  @override
  void initState() {
    super.initState();

    if (Profile!.weight != null)
      initialWeightController.text = Profile!.weight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              texts.afterDehydrationText,
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
          children: [dehydrationPage(context)],
        ));
  }

  Widget dehydrationPage(BuildContext context) {
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
              child: Text(texts.dehydrationText,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary))),
          SizedBox(
            width: 350,
            child: Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(texts.dehydrationDescriptionText,
                    softWrap: true,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary))),
          ),
          Divider(
            height: 15,
            color: Colors.transparent,
          ),
          Text(texts.initialWeightText,
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
                            controller: initialWeightController,
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
          Text(texts.finalWeightText,
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
                            controller: finalWeightController,
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
                      var initialWeight = getInitialWeight();
                      var finalWeight = getFinalWeight();

                      if (finalWeight >= 0.0) {
                        var value = finalWeight / initialWeight * 100.0;
                        value = 100 - value;

                        if (value < 0) {
                          result = texts.hydrationResult1;
                        } else if (value < 1) {
                          result = texts.hydrationResult2;
                        } else if (value < 2) {
                          result = texts.hydrationResult3;
                        } else if (value < 3) {
                          result = texts.hydrationResult4;
                        } else if (value < 4) {
                          result = texts.hydrationResult5;
                        } else if (value < 5) {
                          result = texts.hydrationResult6;
                        } else if (value < 6) {
                          result = texts.hydrationResult7;
                        } else {
                          result = texts.hydrationResult8;
                        }
                        if (finalWeight <= initialWeight) {
                          var remainder = value.remainder(1) == 0;
                          if (remainder) {
                            dehydration = value.toStringAsFixed(0) +
                                "% " +
                                texts.waterLossText +
                                ".";
                          } else {
                            dehydration = value.toStringAsFixed(1) +
                                "% " +
                                texts.waterLossText +
                                ".";
                          }

                          value = (900 * value);
                          remainder = value.remainder(1) == 0;
                          if (remainder) {
                            hydration = (value).toStringAsFixed(0) + " ml";
                          } else {
                            hydration = (value).toStringAsFixed(1) + " ml";
                          }
                        } else {
                          dehydration = "";
                        }
                      } else {
                        dehydration = "";
                        result = "";
                        hydration = "";
                      }
                      setState(() {});
                    }
                  },
                  child: Text(texts.calculateDehydrationText))),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Text(texts.afterDehydrationText,
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
                        dehydration,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15),
                      ))))),
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
                        // maxLines: 1,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12),
                      ))))),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Text(texts.hydrationNecessaryText,
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
                        hydration,
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

  double getInitialWeight() {
    return double.parse(initialWeightController.text);
  }

  double getFinalWeight() {
    return double.parse(finalWeightController.text);
  }

  bool CheckFields() {
    double? initialWeight = double.tryParse(initialWeightController.text);
    if (initialWeight == null) return false;
    double? finalWeight = double.tryParse(finalWeightController.text);
    if (finalWeight == null) return false;

    return true;
  }
}
