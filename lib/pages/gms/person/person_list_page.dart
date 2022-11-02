import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/pagination_view.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/search_list_view.dart';

class PersonListPage extends StatefulWidget {
  const PersonListPage({super.key});

  @override
  PersonListPageState createState() => PersonListPageState();
}

class PersonListPageState extends State<PersonListPage> {
  PersonStore personStore = PersonStore();
  GlobalKey<PaginationState>? paginationKey = GlobalKey();
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
// NOTE: even you didn't select item this method will be called with null of value so you should call your call back with checking if value is not null

      if (value != null) logPrint.w(value);
    });
  }

  Timer? _debounce;
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
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
        title: const Text(("person_list")),
        actions: [
          IconButton(
              onPressed: () {
                _showPopupMenu();
              },
              icon: const Icon(
                //todo:
                  // AntDesign.filter
                Icons.filter
              )
          )
        ],
      ),
      body: Column(
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
                        hintText:
                            ("search_person"),
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        focusedBorder: OutlineInputBorder(
                          borderSide:  const BorderSide(
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
                key: paginationKey,
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
                  return person.getPersonListItemWidget();
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
      floatingActionButton:
      //todo: access check....
        // GlobalData().isAddAccessPresent(ModuleConstants.HR_PERSON)
           GradientButton(
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
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pushNamed("/admin/hr/person/add")
                                      .then((result) async {
                                    if (paginationKey != null) {
                                      paginationKey!.currentState!
                                          .clearList();
                                    }
                                  });
                              },
                              child: const Text(
                                  ("add_single_person")),
                            ),
                            const SizedBox(height: 12),
                            GradientButton(
                              width: Width.full,
                              icon: const Icon(Icons.group_add_outlined),
                              onPressed: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pushNamed("/admin/hr/person/add",
                                          arguments: {"isMultiple": true})
                                      .then((result) async {
                                    if (result != null) {
                                      Map param = result as Map;
                                      List<CustomContact>? list = param['data'];
                                      String personType = param['personType'];
                                      if (list != null && list.isNotEmpty) {
                                        for (int i = 0; i < list.length; i++) {
                                          EmployeeModel employeeModel =
                                              EmployeeModel();
                                          employeeModel.personType = personType;
                                          employeeModel.mobileNo = MobileNoModel.fromString(
                                              list[i].contact!.phones!.first
                                                  ?.value);
                                          employeeModel.personalDetail.name =
                                              list[i].contact!.displayName;
                                          if (list[i].contact!.emails != null &&
                                              list[i].contact!.emails!.isNotEmpty) {
                                            employeeModel.personalDetail.email =
                                                list[i]
                                                    .contact!
                                                    .emails
                                                    !.first
                                                    .value;
                                          }
                                          var resp =
                                              await personStore.addEmployee(employeeModel);
                                          if (resp != null &&
                                              list.length == i - 1) {
                                            DialogViews
                                                .showSuccessBottomSheetForEmployee(
                                              context,
                                              detailText:

                                                      (
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
                              child: const Text(
                                  ("add_multiple_person")),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(("add_person")),
            )
    );
  }
}

