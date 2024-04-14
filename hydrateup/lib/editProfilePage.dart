import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'main.dart';
import 'profileData.dart';
import 'goalsData.dart';
import 'texts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, this.title = "Edit Profile"});
  final String title;
  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  TextEditingController nameController =
      TextEditingController(text: Profile!.name);
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  XFile? avatarFile;
  static Uint8List? avatarB;

  @override
  void initState() {
    super.initState();
    // if (ProfileSuccess && avatarB == null) {
    //   File("avatar").exists().then((value) {
    //     if (value) {
    //       XFile file = XFile("avatar");
    //       file
    //           .readAsBytes()
    //           .then((value) => {avatarB = value, setState(() {})});
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (Profile!.weight != null)
      weightController.text = Profile!.weight.toString();
    if (Profile!.height != null)
      heightController.text = Profile!.height.toString();

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          leading: leading(),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              texts.editProfileText,
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
          children: [profile(context)],
        ));
  }

  Widget? leading() {
    if (ProfileSuccess) {
      return IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, false);
          });
    }
    return null;
  }

  Widget profile(BuildContext context) {
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Padding(
              padding: EdgeInsets.all(15),
              child: Card(
                  elevation: 1,
                  child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text((Profile!.name == null
                          ? texts.profileText
                          : Profile!.name!)),
                      iconColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.primary,
                      tileColor: Theme.of(context).colorScheme.background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))))),
          // Padding(
          //     padding: EdgeInsets.all(5),
          //     child: CircleAvatar(
          //         radius: 45,
          //         child: addAvatar(),
          //        backgroundImage: ImageAvatar())),
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
                      //var profilesucess = ProfileSuccess;
                      saveProfile(nameController.text, getWeight(), getHeight())
                          .then((success) {
                        if (success) {
                          Navigator.pop(context, false);
                          // if (!profilesucess) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                          // } else {
                          updateGoal();
                          // }
                        }
                      });
                    }
                  },
                  child: Text(texts.confirmText)))
        ]));
  }

  ImageProvider? ImageAvatar() {
    if (avatarB != null) {
      return Image.memory(avatarB!).image;
    }
    return null;
  }

  Widget addAvatar() {
    if (avatarB != null) {
      return TextButton(
        onPressed: () {
          pickAvatar();
        },
        child: Text(""),
      );
    }
    return TextButton(
        onPressed: () {
          pickAvatar();
        },
        child: Icon(
          Icons.add_a_photo,
        ));
  }

  Future<void> readAvatar() async {
    avatarB = await avatarFile!.readAsBytes();
    await avatarFile!.saveTo("avatar");
  }

  Future<void> pickAvatar() async {
    ImagePicker imagePicker = ImagePicker();

    XFile? response = await imagePicker.pickImage(source: ImageSource.gallery);
    if (response != null) {
      avatarFile = response;

      // bool storagePermission = await Permission.storage.status.isGranted;
      // if (!storagePermission) {
      //   storagePermission = await Permission.storage.request().isGranted;
      // }
      // if (storagePermission) {
      await readAvatar();
      // }
      File("avatar").exists().then((value) {
        if (value) {
          XFile file = XFile("avatar");
          file
              .readAsBytes()
              .then((value) => {avatarB = value, setState(() {})});
        }
      });
      setState(() {});
    }
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
