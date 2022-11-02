// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:moolwms/constants/Constants.dart';
// import 'package:moolwms/utils/AppLocalizations.dart';
// import 'package:moolwms/model/AppUserRoleLocationMappingModel.dart';
// import 'package:moolwms/utils/SharedPrefs.dart';
// import 'package:moolwms/widgets/ProgressContainerView.dart';
// import 'package:moolwms/store/AuthStore.dart';
// import 'package:moolwms/utils/Utils.dart';
//
// class ModifyPersonRolePage extends StatefulWidget {
//   int personId;
//   ModifyPersonRolePage(dynamic agrs) {
//     if (agrs != null) {
//       personId = agrs["personId"];
//     }
//   }
//
//   @override
//   _ModifyPersonRolePageState createState() => _ModifyPersonRolePageState();
// }
//
// class _ModifyPersonRolePageState extends State<ModifyPersonRolePage> {
//   List<AppUserRoleLocationMappingModel> userRoleList;
//   AuthStore authStore = AuthStore();
//
//   @override
//   void initState() {
//     getUserRoleLocationMappingList();
//     super.initState();
//   }
//
//   Future<void> getUserRoleLocationMappingList() async {
//     userRoleList =
//         await authStore.getUserRoleLocationMapping(context, widget.personId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context).translate("modify_role")),
//       ),
//       body: Observer(builder: (_) {
//         return ProgressContainerView(
//           isProgressRunning: authStore.showProgress ?? false,
//           child: userRoleList != null &&
//                   userRoleList.isNotEmpty
//               ? ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: userRoleList.length,
//                   itemBuilder: (ctx, i) {
//                     if (userRoleList[i].orgId ==
//                         SharedPrefs.getPref(PrefConstants.ORG_ID)) {
//                       return Card(
//                         margin:
//                             const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         child: Container(
//                           padding: const EdgeInsets.all(12),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Warehouse",
//                                       style:
//                                           Theme.of(context).textTheme.caption,
//                                     ),
//                                     Text(
//                                         TextUtils.enumToString(userRoleList[i]
//                                             .locationDetail
//                                             .name),
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .subtitle1
//                                             .copyWith(
//                                                 fontWeight: FontWeight.w600)),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Role",
//                                       style:
//                                           Theme.of(context).textTheme.caption,
//                                     ),
//                                     Text(
//                                       (TextUtils.enumToString(
//                                                   userRoleList[i].role)
//                                               .splitMapJoin(RegExp("[A-Z]"),
//                                                   onMatch: (val) {
//                                             if (val.start == 0) {
//                                               return TextUtils.enumToString(
//                                                       userRoleList[i].role)
//                                                   .substring(
//                                                       val.start, val.end);
//                                             }
//                                             return " " +
//                                                 TextUtils.enumToString(
//                                                         userRoleList[i].role)
//                                                     .substring(
//                                                         val.start, val.end);
//                                           }) ??
//                                           ""),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .subtitle1
//                                           .copyWith(
//                                               fontWeight: FontWeight.w600,
//                                               color: ColorConstants.PRIMARY),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               PopupMenuButton(
//                                   padding: const EdgeInsets.all(0),
//                                   icon: const Icon(Icons.more_vert),
//                                   onSelected: (val) {
//                                     if (val == "EDIT") {
//                                       Navigator.of(context).pushNamed(
//                                           "/admin/gms/person/assignrole",
//                                           arguments: {
//                                             "userId": widget.personId,
//                                             "appUserRoleLocationMappingModel":
//                                                 userRoleList[i],
//                                           }).then((value) async {
//                                         if (value != null &&
//                                             value is bool &&
//                                             value) {
//                                           getUserRoleLocationMappingList();
//                                         }
//                                       });
//                                     } else if (val == "DELETE") {
//                                       authStore
//                                           .deleteUserRoleLocationMapping(
//                                               context, userRoleList[i].id)
//                                           .then((value) async {
//                                         if (value != null &&
//                                             value is bool &&
//                                             value) {
//                                           getUserRoleLocationMappingList();
//                                         }
//                                       });
//                                     }
//                                   },
//                                   itemBuilder: (context) =>
//                                       <PopupMenuEntry<String>>[
//                                         PopupMenuItem(
//                                           value: "EDIT",
//                                           child: Row(
//                                             children: [
//                                               const Icon(Icons.edit),
//                                               const SizedBox(width: 8),
//                                               Text(AppLocalizations.of(context)
//                                                   .translate("edit"))
//                                             ],
//                                           ),
//                                         ),
//                                         PopupMenuItem(
//                                           value: "DELETE",
//                                           child: Row(
//                                             children: [
//                                               const Icon(Icons.delete_outline),
//                                               const SizedBox(width: 8),
//                                               Text(AppLocalizations.of(context)
//                                                   .translate("delete"))
//                                             ],
//                                           ),
//                                         ),
//                                       ]),
//                             ],
//                           ),
//                         ),
//                       );
//                     } else {
//                       return null;
//                     }
//                   },
//                 )
//               : const Center(child: Text("Role Not Assiged!")),
//         );
//       }),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.of(context).pushNamed("/admin/gms/person/assignrole",
//                 arguments: {"userId": widget.personId}).then((value) async {
//               if (value != null && value is bool && value) {
//                 getUserRoleLocationMappingList();
//               }
//             });
//           },
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
