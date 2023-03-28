import 'package:flutter/material.dart';
import 'package:flutter_note/controllers/authController.dart';
import 'package:flutter_note/controllers/noteController.dart';
import 'package:flutter_note/screens/home/add_note.dart';
import 'package:flutter_note/screens/home/note_list.dart';
import 'package:flutter_note/screens/widgets/custom_icon_btn.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<AuthController> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Obx(() => Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconBtn(
                          color: Theme.of(context).colorScheme.background,
                          onPressed: () {
                            authController.axisCount.value =
                                authController.axisCount.value == 2 ? 4 : 2;
                          },
                          icon: Icon(authController.axisCount.value == 2
                              ? Icons.list
                              : Icons.grid_on),
                        ),
                        Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomIconBtn(
                          color: Theme.of(context).colorScheme.background,
                          onPressed: () {
                            showSignOutDialog(context);
                          },
                          icon: Icon(Icons.power_settings_new_outlined,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GetX<NoteController>(
                      init: Get.put<NoteController>(NoteController()),
                      builder: (NoteController noteController) {
                        if (noteController != null &&
                            noteController.notes != null) {
                          return NoteList();
                        } else {
                          return Text("No notes, create some ");
                        }
                      }),
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Note",
          onPressed: () {
            Get.to(() => AddNotePage());
          },
          child: Icon(
            Icons.note_add,
            size: 30,
          )),
    );
  }
}

void showSignOutDialog(BuildContext context) async {
  final AuthController authController = Get.find<AuthController>();
  print("in dialog ");
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(20),
        actionsPadding: EdgeInsets.only(right: 60),
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: Text(
          "Are you sure you want to log out?",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Your notes are already saved so when logging back your notes will be there.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              child: Text("Log Out",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                authController.signout();
                Navigator.of(context).pop();
              })
        ],
      );
    },
  );
}
