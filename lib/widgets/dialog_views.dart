import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/widgets/gradient_button.dart';

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
                            ("done")),
                      ),
                      onPressed: () {
                        //todo:
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
                          (
                              "you_are_not_authorized_to_access_this_feature"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 18),
                  GradientButton(
                      child: const Text(("ok")),
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
                          child: const Text(
                              ("back")),
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
      BuildContext context, String? projectText,
      {VoidCallback? onDismiss,
      Function(String newName)? onNewProjectNameSaved, Function(String newName)? onNewProject}) {
    //todo: controller to be disposed
    TextEditingController taskProjectNameController = TextEditingController();
    if (projectText != null) {
      taskProjectNameController.text = projectText;
    }


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
                    controller: taskProjectNameController,
                    // initialValue: projectText,
                    // onSaved: (val) => taskModel.reminder = val,
                    //enabled: widget.personModel == null,
                    // validator: (val) {
                    //   if (val.isEmptyOrNull) {
                    //     return
                    //         ("task_cannot_be_empty");
                    //   }
                    //   return null;
                    // },
                    decoration: DecorationUtils.getTextFieldDecoration(
                      labelText:
                          ("project"),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Visibility(
                      visible: onDismiss != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              child: const Text(
                                  ("cancel")),
                              onPressed: () {
                                onDismiss!();
                              }),
                          GradientButton(
                              child: projectText !=null ?const Text(
                                  ("update")):const Text(
                              ("add")),
                              onPressed: () {
                                if (projectText != null) {
                                  onNewProjectNameSaved!(
                                      taskProjectNameController.text);
                                } else {
                                  onNewProject!(taskProjectNameController.text);
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

  static void showErrorDialog(BuildContext context, dynamic errorResponse,
      {Function? onOKPressed}) {
    String errorTitle = "", errorMsg = "", buttonText = "OK";
    bool dismissible = true;

    // if (errorResponse is DioError) {
    //   if (errorResponse.error is SocketException) {
    //     errorTitle = "Network Error";
    //     errorMsg =
    //     "There is some issue with your internet connection. Please check your internet connection settings and try again.";
    //   } else if (errorResponse.response != null) {
    //     if (errorResponse.response.data is Map &&
    //         errorResponse.response.data.containsKey("error")) {
    //       var errorDetails =
    //       APIErrorModel.fromJson(errorResponse.response.data['error']);
    //       errorTitle = errorResponse.response.statusMessage;
    //       errorMsg = errorDetails.message;
    //     } else {
    //       errorTitle = errorResponse.response.statusMessage;
    //       errorMsg = errorResponse.response.data.toString();
    //     }
    //   } else {
    //     errorTitle = "API Error";
    //     errorMsg = errorResponse?.message ??
    //         "There was some problem while connecting to the server.";
    //   }
    // } else {
    //   errorTitle = "Error";
    //   errorMsg = errorResponse.toString();
    // }
    showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(dismissible);
            },
            child: AlertDialog(
              title: Text(errorTitle),
              content: Text(errorMsg),
              actions: <Widget>[
                TextButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                    if (onOKPressed != null) {
                      onOKPressed();
                    }
                  }),
                  child: Text(buttonText),
                )
              ],
            ),
          );
        });
  }
}
