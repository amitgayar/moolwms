import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/constants/APIConstants.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/AppUserDetailModel.dart';
import 'package:moolwms/model/GlobalData.dart';
import 'package:moolwms/store/GateStore.dart';
import 'package:moolwms/store/AuthStore.dart';
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/model/gate_transactional_model.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/utils/SharedPrefs.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/utils/Utils.dart';
import 'package:moolwms/constants/Globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:moolwms/model/AppUserRoleLocationMappingModel.dart';

class PersonDetailsPage extends StatefulWidget {
  GateTransactionModel gateTxn;
  PersonModel personModel;
  PersonDetailsPage(dynamic args) {
    personModel = args['person'];
    gateTxn = args['gateTxn'];
  }

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage>
    with SingleTickerProviderStateMixin {
  PersonModel personModel;
  PersonStore personStore = PersonStore();
  AuthStore authStore = AuthStore();
  GateStore gateStore = GateStore();
  TabController _tabController;
  List<GateTransactionModel> gateTransactions;
  AppUserDetailsModel appUserDetailsModel;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    personModel = widget.personModel;
    initData();
    super.initState();
  }

  Future<void> initData() async {
    personModel = await personStore.getPerson(context, personModel?.mobileNo);
    await gepAppUser();
    gateTransactions = await gateStore.getPersonListByDateRange(
        personModel.id,
        DateTime(DateTime.now().year, DateTime.now().month, 1),
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
  }

  Future<void> gepAppUser() async {
    appUserDetailsModel = await authStore.getAppUserByMobileNumber(
        context, personModel?.mobileNo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 4,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              personModel?.fullName ?? "",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: ColorConstants.PRIMARY),
            ),
          ],
        ),
        actions: [
          Visibility(
            visible: personModel?.mobileNo != null,
            child: IconButton(
                tooltip: AppLocalizations.of(context).translate("call"),
                icon: const Icon(Icons.call, color: ColorConstants.PRIMARY),
                onPressed: () {
                  try {
                    launch(('tel://${personModel?.mobileNo?.fullNumber}'));
                  } catch (e) {
                    logPrint.w(e);
                  }
                }),
          ),
          Observer(builder: (_) {
            return Visibility(
              visible: personModel?.empId != null,
              child: IconButton(
                  tooltip: AppLocalizations.of(context).translate("edit"),
                  icon: const Icon(Icons.edit, color: ColorConstants.PRIMARY),
                  onPressed: () {
                    String persontype;
                    if (personModel?.personType?.value == 1) {
                      persontype = 'employee';
                    } else if (personModel?.personType?.value == 6) {
                      persontype = 'contracted_employee';
                    } else if (personModel?.personType?.value == 8) {
                      persontype = 'intern';
                    }
                    Navigator.of(context)
                        .pushNamed('/admin/hr/person/add/details', arguments: {
                      "personType": persontype,
                      "employee": personModel.employee
                    }).then((result) {
                      if (result != null && result is bool && result) {
                        personStore
                            .getPerson(context, personModel.mobileNo)
                            .then((value) {
                          personModel = value;
                        });
                      }
                    });
                  }),
            );
          }),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: ColorConstants.PRIMARY,
          indicatorColor: ColorConstants.PRIMARY,
          indicatorWeight: 3,
          labelStyle: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: AppLocalizations.of(context).translate("details")),
            Tab(text: AppLocalizations.of(context).translate("attendance")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Observer(builder: (_) {
            return ProgressContainerView(
              isProgressRunning: (personStore?.showProgress ?? false) ||
                  (authStore.showProgress ?? false),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.gateTxn != null
                        ? widget.gateTxn.getTransactionListItem(context)
                        : Container(),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("name"),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                  personModel?.fullName ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                              ],
                            ),
                            VisibilityExtended(
                              visible:
                                  !(personModel?.fathersName?.isEmptyOrNull ??
                                      true),
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("father_name"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.fathersName ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible: personModel?.gender != null,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("gender"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.gender?.label ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("mobile_number"),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                  personModel?.mobileNo?.fullNumber ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                              ],
                            ),
                            VisibilityExtended(
                              visible: !(personModel
                                      ?.address?.addressLine1?.isEmptyOrNull ??
                                  true),
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("address"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.address?.addressLine1 ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible: personModel?.address?.pincode != null,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("pincode"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.address?.pincode
                                                ?.toString() ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible: personModel?.address?.city != null,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("city"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.address?.city ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible: personModel?.address?.state != null,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("state"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.address?.state?.name ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            widget.gateTxn != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Divider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      "current_access_time"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Text(
                                            DateFormat("hh:mm:ss aa").format(
                                                    widget.gateTxn
                                                        ?.createdDate) ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ))
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      "current_access_date"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Text(
                                            DateFormat("dd MMM yyyy").format(
                                                    widget.gateTxn
                                                        ?.createdDate) ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ))
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(),
                            VisibilityExtended(
                              visible: personModel?.govtIdType != null,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("id_type"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.govtIdType?.label ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible:
                                  !(personModel?.govtIdNumber?.isEmptyOrNull ??
                                      true),
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("id_number"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.govtIdNumber ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("person_type"),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                  personModel?.personType?.label ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                              ],
                            ),
                            VisibilityExtended(
                              visible: personModel?.reportingManager != null,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("reporting_manager"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.reportingManager?.name ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible: widget.gateTxn?.visitorPurpose != null,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("purpose"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        widget.gateTxn?.visitorPurpose ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible: !personModel.internCode.isEmptyOrNull,
                              child: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("intern_code"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                        personModel?.internCode ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VisibilityExtended(
                              visible: personModel?.image != null,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("image"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Card(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: ImageUtils.loadImage(
                                                      FileContainerAPIs.getFileURL(
                                                          APIConstants
                                                              .PERSON_IMAGE_CONTAINER,
                                                          personModel?.image),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3),
                                                ),
                                                InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    onTap: () async {
                                                      if (await canLaunch(
                                                          FileContainerAPIs
                                                              .getFileURL(
                                                                  APIConstants
                                                                      .PERSON_IMAGE_CONTAINER,
                                                                  personModel
                                                                      ?.image))) {
                                                        await launch(FileContainerAPIs
                                                            .getFileURL(
                                                                APIConstants
                                                                    .PERSON_IMAGE_CONTAINER,
                                                                personModel
                                                                    ?.image));
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 1,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                            )
                                                          ]),
                                                      child: const CircleAvatar(
                                                        radius: 18,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                            Icons.open_in_new,
                                                            size: 20,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VisibilityExtended(
                      visible: personModel?.labour != null,
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(top: 24),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              VisibilityExtended(
                                visible: personModel?.labour?.dailyWage != null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("daily_wage"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          (personModel?.labour?.dailyWage ?? 0)
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel
                                        ?.labour?.esicNumber?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("esic_number"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          (personModel?.labour?.esicNumber ?? 0)
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    VisibilityExtended(
                      visible: personModel?.truckDriver != null,
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(top: 24),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              VisibilityExtended(
                                visible: !(personModel?.truckDriver
                                        ?.drivingLicense?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("driving_license"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.truckDriver
                                                  ?.drivingLicense ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel?.truckDriver
                                        ?.transporterCompany?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    "transporter_company"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.truckDriver
                                                  ?.transporterCompany ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    VisibilityExtended(
                      visible: personModel?.employee != null,
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(top: 24),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              VisibilityExtended(
                                visible: personModel?.employee?.personalDetail
                                        ?.maritalStatus !=
                                    null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("marital_status"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.maritalStatus?.label ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: personModel?.employee?.personalDetail
                                        ?.nationality !=
                                    null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("nationality"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.nationality?.label ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel?.employee?.personalDetail
                                        ?.pfNo?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("pf_no"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.pfNo ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: personModel?.employee?.personalDetail
                                        ?.countryOfBirth !=
                                    null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("country_of_birth"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.countryOfBirth?.label ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel?.employee?.personalDetail
                                        ?.bloodGroup?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("blood_group"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.bloodGroup ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: personModel?.employee?.personalDetail
                                        ?.disability !=
                                    null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("disability"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.disability ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: personModel
                                        ?.employee?.personalDetail?.email !=
                                    null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("email"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.email ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel?.employee?.personalDetail
                                        ?.esicNo?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("esic_number"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.personalDetail
                                                  ?.esicNo ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: personModel?.employee?.contactDetail
                                            ?.emergencyContactNo !=
                                        null &&
                                    personModel?.employee?.contactDetail
                                            ?.emergencyContactNo?.number !=
                                        null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("emergency_number"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel
                                                  ?.employee
                                                  ?.contactDetail
                                                  ?.emergencyContactNo
                                                  ?.fullNumber ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    VisibilityExtended(
                      visible: personModel?.employee?.personalDetail
                                  ?.employeeRelations !=
                              null &&
                          (personModel?.employee?.personalDetail
                                      ?.employeeRelations?.length ??
                                  0) >
                              0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: personModel?.employee?.personalDetail
                                ?.employeeRelations?.length ??
                            0,
                        itemBuilder: (ctx, i) {
                          return personModel
                              ?.employee?.personalDetail?.employeeRelations[i]
                              ?.getListItemWidget(ctx);
                        },
                      ),
                    ),
                    VisibilityExtended(
                      visible: personModel?.employee?.bankDetail != null &&
                          personModel?.employee?.bankDetail?.bank != null,
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(top: 24),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              VisibilityExtended(
                                visible: !(personModel?.employee?.bankDetail
                                        ?.accountName?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("account_name"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.bankDetail
                                                  ?.accountName ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel?.employee?.bankDetail
                                        ?.accountNumber?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("account_number"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.bankDetail
                                                  ?.accountNumber ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel?.employee?.bankDetail
                                        ?.ifscCode?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("ifsc_code"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.bankDetail
                                                  ?.ifscCode ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible:
                                    personModel?.employee?.bankDetail?.bank !=
                                        null,
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("bank_name"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.bankDetail
                                                  ?.bank?.label ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: !(personModel?.employee?.bankDetail
                                        ?.branchName?.isEmptyOrNull ??
                                    true),
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("branch_name"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.bankDetail
                                                  ?.branchName ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VisibilityExtended(
                                visible: personModel
                                        ?.employee?.bankDetail?.accountType !=
                                    null,
                                child: Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("account_type"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                          personModel?.employee?.bankDetail
                                                  ?.accountType?.label ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
          Observer(builder: (_) {
            return ProgressContainerView(
              isProgressRunning: gateStore?.showProgress ?? false,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: CalendarCarousel<Event>(
                  onCalendarChanged: (dateTime) {
                    logPrint.w("CalendarChanged: $dateTime");
                    gateStore
                        .getPersonListByDateRange(
                            personModel.id,
                            DateTime(dateTime.year, dateTime.month, 1),
                            DateTime(dateTime.year, dateTime.month + 1, 0))
                        .then((value) => gateTransactions = value);
                  },
                  dayPadding: 4,
                  weekendTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  onDayPressed: (day, event) {
                    // print
                    List<GateTransactionModel> gateTrxnList = gateTransactions
                        .where((element) =>
                            DateTime(
                                element.createdDate.year,
                                element.createdDate.month,
                                element.createdDate.day) ==
                            day)
                        .toList();
                    if (gateTrxnList?.isNotEmpty ?? false) {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12))),
                              margin: const EdgeInsets.all(0),
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                DateFormat("dd-MMM-yyyy")
                                                    .format(day),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: gateTrxnList.length,
                                        itemBuilder: (context, pos) {
                                          return gateTrxnList[pos]
                                              .getTransactionListItem(context);
                                        },
                                      ),
                                    )
                                  ])),
                            );
                          });
                    }
                  },
                  thisMonthDayBorderColor: Colors.grey,
                  customDayBuilder: (
                    bool isSelectable,
                    int index,
                    bool isSelectedDay,
                    bool isToday,
                    bool isPrevMonthDay,
                    TextStyle textStyle,
                    bool isNextMonthDay,
                    bool isThisMonthDay,
                    DateTime day,
                  ) {
                    if (gateTransactions?.any((element) =>
                            DateTime(
                                element.createdDate.year,
                                element.createdDate.month,
                                element.createdDate.day) ==
                            day) ??
                        false) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(day.day.toString(),
                            style: textStyle.copyWith(color: Colors.white)),
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                      );
                    }
                    return null;
                  },
                  weekFormat: false,
                  daysHaveCircularBorder: null,
                  todayButtonColor: Colors.transparent,
                  todayTextStyle: const TextStyle(color: Colors.black),
                ),
              ),
            );
          })
        ],
      ),
      bottomNavigationBar: VisibilityExtended(
        visible: GlobalData().currentRoleMapping != null &&
                GlobalData()
                        .currentRoleMapping
                        .roleStructure
                        .modulePermissions
                        .gmsPerson
                        .edit ==
                    1
            ? true
            : false,
        child: Observer(builder: (_) {
          return BottomButtonsContainer(
            children: [
              appUserDetailsModel != null
                  ? GradientButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            "/admin/gms/person/modifyrole",
                            arguments: {"personId": appUserDetailsModel?.id});
                      },
                      child: Text(AppLocalizations.of(context)
                          .translate("modify_role")),
                    )
                  : GradientButton(
                      onPressed: () async {
                        appUserDetailsModel =
                            await authStore.createAppUserWithoutMapping(
                          context,
                          personModel?.mobileNo,
                          personModel?.fullName,
                          personModel?.employee?.personalDetail?.email,
                          UserRole.None,
                        );
                        setState(() {});
                      },
                      child: Text(AppLocalizations.of(context)
                          .translate("generate_app_login")),
                    )
            ],
          );
        }),
      ),
    );
  }
}
