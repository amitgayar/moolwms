import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'gradient_button.dart';

class DialogViews {
  static void showSuccessBottomSheet(BuildContext context,
      {String? detailText,
      String? successText,
      String? doneText,
      VoidCallback? onSuccess}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Card(
            margin: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.done, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(detailText ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 18),
                  Visibility(
                      visible: onSuccess != null,
                      child: GradientButton(
                          child: Text(successText ?? ""),
                          onPressed: () {
                            onSuccess!();
                          })),
                  TextButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4.0),
                        child: Text(doneText ??
                            // ("done")
                              ("Done")
                        ),
                      ),
                      onPressed: () {
                        //todo: navigator
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     globals.authStore?.appUser?.routeToDashboard,
                        //     (context) => false);
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showUnauthorizedBottomSheet(BuildContext context,
      {String? detailText, VoidCallback? onOKPressed}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Card(
            margin: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.warning, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                      detailText ??
                          // ("you_are_not_authorized_to_access_this_feature"),
                      ("You are not authorized to access this feature"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 18),
                  GradientButton(
                      child: const Text(
                          // ("ok")
                            ("OK")
                      ),
                      onPressed: () {
                        if (onOKPressed != null) {
                          onOKPressed();
                        } else {
                          Navigator.of(context).pop();
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showSuccessBottomSheetForEmployee(BuildContext context,
      {String? detailText, VoidCallback? onSuccess}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Card(
            margin: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.done, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(detailText ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 18),
                  Visibility(
                      visible: onSuccess != null,
                      child: GradientButton(
                          child: Text(
                              // ("back")
                                ("Back")
                          ),
                          onPressed: () {
                            onSuccess!();
                          })),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static editProjectBottomSheetForTaskManagement(
      BuildContext context, String projectText,
      {VoidCallback? onDismiss,
      Function(String newName)? onNewProjectNameSaved, Function(String newName)? onNewProject}) {
    //todo: controller to be disposed
    TextEditingController _taskProjectNameController = TextEditingController();
    if (projectText != null) _taskProjectNameController.text = projectText;


    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Card(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _taskProjectNameController,
                    decoration: DecorationUtils.getTextFieldDecoration(
                      labelText:
                      // ("project"),
                      ("Project"),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Visibility(
                      visible: onDismiss != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              child: Text(
                                  // ("cancel")
                                    ("Cancel")
                                  ),
                              onPressed: () {
                                onDismiss!();
                              }),
                          GradientButton(
                              child: projectText!=null?Text(
                                  // ("update")
                                  ("Update")
                                  ):Text(
                              // ("add")
                                ("Add")
                              ),
                              onPressed: () {
                                if (projectText != null) {
                                  onNewProjectNameSaved!(
                                      _taskProjectNameController.text);
                                } else {
                                  onNewProject!(_taskProjectNameController.text);
                                }
                              }),
                        ],
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
