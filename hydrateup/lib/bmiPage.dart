import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'profileData.dart';
import 'texts.dart';

class BMI extends StatefulWidget {
  const BMI({super.key, this.title = 'BMI'});
  final String title;
  @override
  State<BMI> createState() => _BMI();
}

class _BMI extends State<BMI> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  double? bmiValue;
  String result = "";

  @override
  void initState() {
    super.initState();

    if (Profile!.weight != null)
      weightController.text = Profile!.weight.toString();
    if (Profile!.height != null)
      heightController.text = Profile!.height.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              texts.bmiText,
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
          children: [bmi(context)],
        ));
  }

  Widget bmi(BuildContext context) {
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
              child: Text(texts.bodyMassIndexText,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary))),
          SizedBox(
            width: 350,
            child: Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(texts.bmiDescriptionText,
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
          Text(texts.heightText,
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
                            controller: heightController,
                          ))),
                  Padding(
                    padding: EdgeInsets.only(left: 180, top: 15),
                    child: Text(
                      "cm",
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
                      var Weight = getWeight();
                      var Height = getHeight() * .01;
                      print(Weight.toString() +
                          " / " +
                          Height.toString() +
                          " * " +
                          Height.toString());
                      bmiValue = Weight / (Height * Height);

                      if (bmiValue! < 18.5) {
                        result = texts.underweithText;
                      } else if (bmiValue! < 25) {
                        result = texts.normalText;
                      } else if (bmiValue! < 30) {
                        result = texts.overweithText;
                      } else if (bmiValue! < 35) {
                        result = texts.obesity1;
                      } else if (bmiValue! < 40) {
                        result = texts.obesity2;
                      } else {
                        result = texts.obesity3;
                      }
                      setState(() {});
                    }
                  },
                  child: Text(texts.calculateBMIText))),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Text(texts.bmiText,
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
                        (bmiValue == null) ? "" : bmiValue!.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 25),
                      ))))),
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

  double getHeight() {
    return double.parse(heightController.text);
  }

  bool CheckFields() {
    double? weight = double.tryParse(weightController.text);
    if (weight == null) return false;
    double? height = double.tryParse(heightController.text);
    if (height == null) return false;

    return true;
  }
}
