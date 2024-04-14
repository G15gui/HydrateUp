import 'package:flutter/material.dart';

import 'afterDehydrationPage.dart';
import 'bmiPage.dart';
import 'hydrationPage.dart';
import 'editProfilePage.dart';
import 'texts.dart';

// import 'main.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

Widget menuNavigationDrawer(BuildContext context) {
  return Stack(children: [
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              })),
      Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, false);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BMI()));
            },
            leading: Icon(Icons.linear_scale),
            title: Text(texts.bmiText),
            iconColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.primary,
          )),
      Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Hydration()));
            },
            leading: Icon(Icons.battery_charging_full),
            title: Text(texts.hydrationText),
            iconColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.primary,
          )),
      Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dehydration()));
            },
            leading: Icon(Icons.battery_charging_full),
            title: Text(texts.afterDehydrationText),
            iconColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.primary,
          )),
    ]),
    Padding(
        padding: EdgeInsets.only(top: 350),
        child: ListView(reverse: true, children: [
          Padding(
              padding: EdgeInsets.all(15),
              child: ListTile(
                  onTap: () {
                    Navigator.pop(context, false);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                  leading: Icon(Icons.person),
                  title: Text(texts.profileText),
                  iconColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.primary,
                  tileColor: Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))))
        ])),
  ]);
}
