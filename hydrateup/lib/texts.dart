import 'package:flutter/material.dart';

import 'app_localizations.dart';

late BuildContext ocontext;
void initTexts(context) {
  try {
    ocontext = context;
  } catch (error) {}
}

class texts {
  static String editProfileText =
      AppLocalizations.of(ocontext).translate('editProfile');
  static String profileText =
      AppLocalizations.of(ocontext).translate('profile');
  static String nameText = AppLocalizations.of(ocontext).translate('name');
  static String heightText = AppLocalizations.of(ocontext).translate('height');
  static String weightText = AppLocalizations.of(ocontext).translate('weight');
  static String confirmText =
      AppLocalizations.of(ocontext).translate('confirm');
  static String bmiText = AppLocalizations.of(ocontext).translate('bmi');
  static String hydrationText =
      AppLocalizations.of(ocontext).translate('hydration');
  static String dehydrationText =
      AppLocalizations.of(ocontext).translate('dehydration');

  static String afterDehydrationText =
      AppLocalizations.of(ocontext).translate('afterDehydration');
  static String editGoalsText =
      AppLocalizations.of(ocontext).translate('editGoals');
  static String waterText = AppLocalizations.of(ocontext).translate('water');
  static String WaterText = AppLocalizations.of(ocontext).translate('Water');
  static String createGoalText =
      AppLocalizations.of(ocontext).translate('createGoal');
  static String measureText =
      AppLocalizations.of(ocontext).translate('measure');
  static String goalText = AppLocalizations.of(ocontext).translate('goal');
  static String createText = AppLocalizations.of(ocontext).translate('create');
  static String calculateText =
      AppLocalizations.of(ocontext).translate('calculate');
  static String bodyMassIndexText =
      AppLocalizations.of(ocontext).translate('bodyMassIndex');
  static String hydrationWhileExercisingText =
      AppLocalizations.of(ocontext).translate('hydrationWhileExercising');

  static String bmiDescriptionText =
      AppLocalizations.of(ocontext).translate('bmiDescription');
  static String hydrationDescriptionText =
      AppLocalizations.of(ocontext).translate('hydrationDescription');
  static String dehydrationDescriptionText =
      AppLocalizations.of(ocontext).translate('dehydrationDescription');
  static String calculateBMIText =
      AppLocalizations.of(ocontext).translate('calculateBMI');
  static String resultText = AppLocalizations.of(ocontext).translate('result');
  static String underweithText =
      AppLocalizations.of(ocontext).translate('underweith');
  static String normalText = AppLocalizations.of(ocontext).translate('normal');
  static String overweithText =
      AppLocalizations.of(ocontext).translate('overweith');
  static String obesity1 = AppLocalizations.of(ocontext).translate('obesity1');
  static String obesity2 = AppLocalizations.of(ocontext).translate('obesity2');
  static String obesity3 = AppLocalizations.of(ocontext).translate('obesity3');
  static String to = AppLocalizations.of(ocontext).translate('to');
  static String mlPerHour = AppLocalizations.of(ocontext).translate('ml/hour');
  static String calculateHydrationText =
      AppLocalizations.of(ocontext).translate('calculateHydration');

  static String calculateDehydrationText =
      AppLocalizations.of(ocontext).translate('calculateDehydration');

  static String initialWeightText =
      AppLocalizations.of(ocontext).translate('initialWeight');
  static String finalWeightText =
      AppLocalizations.of(ocontext).translate('finalWeight');
  static String hydrationNecessaryText =
      AppLocalizations.of(ocontext).translate('hydrationNecessary');
  static String waterLossText =
      AppLocalizations.of(ocontext).translate('waterLoss');
  static String hydrationResult1 =
      AppLocalizations.of(ocontext).translate('hydrationResult1');
  static String hydrationResult2 =
      AppLocalizations.of(ocontext).translate('hydrationResult2');
  static String hydrationResult3 =
      AppLocalizations.of(ocontext).translate('hydrationResult3');
  static String hydrationResult4 =
      AppLocalizations.of(ocontext).translate('hydrationResult4');
  static String hydrationResult5 =
      AppLocalizations.of(ocontext).translate('hydrationResult5');
  static String hydrationResult6 =
      AppLocalizations.of(ocontext).translate('hydrationResult6');
  static String hydrationResult7 =
      AppLocalizations.of(ocontext).translate('hydrationResult7');
  static String hydrationResult8 =
      AppLocalizations.of(ocontext).translate('hydrationResult8');
  static String editAlarmsText =
      AppLocalizations.of(ocontext).translate('editAlarms');
  static String alarmsTexts = AppLocalizations.of(ocontext).translate('alarms');
}
