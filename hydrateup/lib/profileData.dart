import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  String? name;
  double? weight;
  double? height;

  ProfileData({required this.name, required this.weight, required this.height});
}

ProfileData? Profile;
String profileName = "profile_name";
String profileWeight = "profile_weight";
String profileHeight = "profile_height";
bool ProfileSuccess = false;

Future<bool> saveProfile(String name, double weight, double height) async {
  Profile = ProfileData(name: name, weight: weight, height: height);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  ProfileSuccess = await prefs.setString(profileName, name) &&
      await prefs.setDouble(profileWeight, weight) &&
      await prefs.setDouble(profileHeight, height);

  //UpdateDefaultGoal();
  return ProfileSuccess;
}

Future<bool> loadProfile() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();

  String? name = prefs.getString(profileName);
  double? weight = prefs.getDouble(profileWeight);
  double? height = prefs.getDouble(profileHeight);

  Profile = ProfileData(name: name, weight: weight, height: height);

  ProfileSuccess = (weight != null && height != null);

  if (weight == null) return false;
  if (height == null) return false;

  // if (name != null) await prefs.setString(profileName, name);
  // await prefs.setDouble(profileWeight, weight);
  // await prefs.setDouble(profileHeight, height);

  return ProfileSuccess;
}
