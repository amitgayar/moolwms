import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/ContactModel.dart';
import 'package:moolwms/model/GlobalData.dart';
import 'package:moolwms/model/MobileNoModel.dart';
import 'package:moolwms/model/OptionModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Utils.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/PaginationView.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/SearchListView.dart';

class PersonListPage extends StatefulWidget {
  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  PersonStore personStore = PersonStore();
  GlobalKey<PaginationState> paginatorGlobalKey = GlobalKey();
  String searchedValue = '';

  Future<List<PersonModel>> getPersonDetails() async {
    List<PersonModel> personList = await personStore.getPersonList(
      personSearch: searchedValue,
    );
    return personList;
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        const PopupMenuItem(
          value: 1,
          child: Text("Employee"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Intern"),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text("Contracted Employee"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) logPrint.w(value);
    });
  }

  Timer _debounce;
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 3000), () {
      // do something with query
      setState(() {
        searchedValue = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("person_list")),
        actions: [
          IconButton(
              onPressed: () {
                _showPopupMenu();
              },
              icon: const Icon(AntDesign.filter))
        ],
      ),
      body: Observer(builder: (_) {
        return ProgressContainerView(
          isProgressRunning: personStore?.showProgress ?? false,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: TextFormField(
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 2, left: 10),
                            hintText: AppLocalizations.of(context)
                                .translate("search_person"),
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorConstants.GREY_SEARCH_BORDER),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorConstants.GREY_SEARCH_BORDER),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          )))),
              Expanded(
                  flex: 9,
                  child: searchedValue == ""
                      ? Pagination<PersonModel>(
                          key: paginatorGlobalKey,
                          padding: const EdgeInsets.only(bottom: 90),
                          pageBuilder: (currentListSize) {
                            if (currentListSize == 0 || currentListSize >= 10) {
                              return personStore.getPersonList(
                                  personSearch: '',
                                  limit: 100,
                                  offset: currentListSize);
                            } else {
                              var completer =
                                  Completer<List<PersonModel>>();

                              // At some time you need to complete the future:
                              completer.complete(<PersonModel>[]);

                              return completer.future;
                            }
                          },
                          itemBuilder: (pos, person) {
                            return person.getPersonListItemWidget(context);
                          },
                        )
                      : FutureBuilder(
                          future: getPersonDetails(),
                          builder: (context,
                              AsyncSnapshot<List<PersonModel>> snapshot) {
                            if (!snapshot.hasData) {
                              return PaginationState().defaultLoading();
                            }
                            return SearchList(
                              personList: snapshot.data,
                            );
                          })),
            ],
          ),
        );
      }),
      floatingActionButton: GlobalData()
              .isAddAccessPresent(ModuleConstants.HR_PERSON)
          ? GradientButton(
              child: Text(AppLocalizations.of(context).translate("add_person")),
              icon: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) {
                    return Card(
                      margin: const EdgeInsets.all(0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GradientButton(
                              width: Width.full,
                              child: Text(AppLocalizations.of(context)
                                  .translate("add_single_person")),
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pushNamed("/admin/hr/person/add")
                                      .then((result) async {
                                    if (paginatorGlobalKey != null) {
                                      paginatorGlobalKey.currentState
                                          .clearList();
                                    }
                                  });
                              },
                            ),
                            const SizedBox(height: 12),
                            GradientButton(
                              width: Width.full,
                              child: Text(AppLocalizations.of(context)
                                  .translate("add_multiple_person")),
                              icon: const Icon(Icons.group_add_outlined),
                              onPressed: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pushNamed("/admin/hr/person/add",
                                          arguments: {"isMultiple": true})
                                      .then((result) async {
                                    if (result != null) {
                                      Map param = result as Map;
                                      List<CustomContact> list = param['data'];
                                      String personType = param['personType'];
                                      if (list != null && list.isNotEmpty) {
                                        for (int i = 0; i < list.length; i++) {
                                          EmployeeModel employeeModel =
                                              EmployeeModel();
                                          employeeModel.personType = personType;
                                          employeeModel.mobileNo =
                                              MobileNoModel.fromString(list[i]
                                                  .contact
                                                  .phones
                                                  .first
                                                  ?.value);
                                          employeeModel.personalDetail.name =
                                              list[i].contact.displayName;
                                          if (list[i].contact.emails != null &&
                                              list[i].contact.emails.isNotEmpty) {
                                            employeeModel.personalDetail.email =
                                                list[i]
                                                    .contact
                                                    .emails
                                                    .first
                                                    .value;
                                          }
                                          var resp =
                                              await personStore.addEmployee(
                                                  context, employeeModel);
                                          if (resp != null &&
                                              list.length == i - 1) {
                                            DialogViews
                                                .showSuccessBottomSheetForEmployee(
                                              context,
                                              detailText:
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          "added_successful"),
                                              onSuccess: () =>
                                                  Navigator.of(context)
                                                    ..pop()
                                                    ..pop(),
                                            );
                                          }
                                        }
                                      }
                                    }
                                  });
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const SizedBox(),
    );
  }
}
