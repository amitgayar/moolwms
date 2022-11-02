import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/widgets/my_image_cropper.dart';
import 'package:moolwms/widgets/visibility_extended.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonDetailsPage extends StatefulWidget {
  final GateTransactionModel? gateTxn;
  final PersonModel personModel;

  const PersonDetailsPage({super.key, required this.gateTxn, required this.personModel});


  @override
  PersonDetailsPageState createState() => PersonDetailsPageState();
}

class PersonDetailsPageState extends State<PersonDetailsPage> with SingleTickerProviderStateMixin {
  PersonModel? personModel;
  PersonStore personStore = PersonStore();
  AuthStore authStore = AuthStore();
  GateStore gateStore = GateStore();
  TabController? _tabController;
  List<GateTransactionModel>? gateTransactions;
  AppUserDetailsModel? appUserDetailsModel;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    personModel = widget.personModel;
    initData();
    super.initState();
  }

  Future<void> initData() async {
    personModel = await personStore.getPerson(personModel?.mobileNo);
    await gepAppUser();
    gateTransactions = await gateStore.getPersonListByDateRange(
        personModel!.id,
        DateTime(DateTime.now().year, DateTime.now().month, 1),
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
  }

  Future<void> gepAppUser() async {
    appUserDetailsModel = await authStore.getAppUserByMobileNumber(
        personModel?.mobileNo);
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
                  .headline6!
                  .copyWith(color: ColorConstants.primary),
            ),
          ],
        ),
        actions: [
          Visibility(
            visible: personModel?.mobileNo != null,
            child: IconButton(
                tooltip: ("call"),
                icon: const Icon(Icons.call, color: ColorConstants.primary),
                onPressed: () {
                  try {
                    launch(('tel://${personModel?.mobileNo?.fullNumber}'));
                  } catch (e) {
                    logPrint.w(e);
                  }
                }),
          ),
          Visibility(
            visible: (personModel?.empId != null),
            child: IconButton(
                tooltip: ("edit"),
                icon: const Icon(Icons.edit, color: ColorConstants.primary),
                onPressed: () {
                  String? personType;
                  if (personModel?.personType?.value == 1) {
                    personType = 'employee';
                  } else if (personModel?.personType?.value == 6) {
                    personType = 'contracted_employee';
                  } else if (personModel?.personType?.value == 8) {
                    personType = 'intern';
                  }
                  Navigator.of(context)
                      .pushNamed('/admin/hr/person/add/details', arguments: {
                    "personType": personType,
                    "employee": personModel?.employee
                  }).then((result) {
                    if (result != null && result is bool && result) {
                      personStore
                          .getPerson(personModel?.mobileNo)
                          .then((value) {
                        personModel = value;
                      });
                    }
                  });
                }),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: ColorConstants.primary,
          indicatorColor: ColorConstants.primary,
          indicatorWeight: 3,
          labelStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: ("details")),
            Tab(text: ("attendance")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //todo: loader
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.gateTxn != null
                    ? widget.gateTxn!.getTransactionListItem()
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

                                ("name"),
                                style:
                                Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  personModel?.fullName ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
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

                                      ("father_name"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.fathersName ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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

                                      ("gender"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.gender?.label ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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

                                ("mobile_number"),
                                style:
                                Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  personModel?.mobileNo?.fullNumber ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
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

                                      ("address"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.address?.addressLine1 ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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
                                      // ("pincode"),
                                      ("PinCode"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
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
                                            .bodyText1!
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

                                      ("city"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.address?.city ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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

                                      ("state"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.address?.state?.name ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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

                                    (
                                        "current_access_time"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                      DateFormat("hh:mm:ss aa").format(
                                          widget.gateTxn!.createdDate!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
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

                                    (
                                        "current_access_date"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                      DateFormat("dd MMM yyyy").format(
                                          widget.gateTxn!
                                              .createdDate!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
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

                                      ("id_type"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.govtIdType?.label ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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

                                      ("id_number"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.govtIdNumber ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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

                                ("person_type"),
                                style:
                                Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  personModel?.personType?.label ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
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

                                      ("reporting_manager"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.reportingManager?.name ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                            fontWeight: FontWeight.w600),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        VisibilityExtended(
                          visible: widget.gateTxn!.visitorPurpose != null,
                          child: Column(
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(

                                      ("purpose"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        widget.gateTxn!.visitorPurpose ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                            fontWeight: FontWeight.w600),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        VisibilityExtended(
                          visible: !personModel!.internCode!.isEmpty,
                          child: Column(
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(

                                      ("intern_code"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.internCode ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
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

                                      ("image"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
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
                                                    "",
                                                      // APIConstants.PERSON_IMAGE_CONTAINER,
                                                      personModel?.image
                                                  ),
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
                                                        "",
                                                          // APIConstants
                                                          //     .PERSON_IMAGE_CONTAINER,
                                                          personModel
                                                              ?.image))) {
                                                    await launch(FileContainerAPIs
                                                        .getFileURL(
                                                        "",

                                                        // APIConstants
                                                        //     .PERSON_IMAGE_CONTAINER,
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

                                        ("daily_wage"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(
                                          (personModel?.labour?.dailyWage ?? 0)
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
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

                                        ("esic_number"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(
                                          (personModel?.labour?.esicNumber ?? 0)
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
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

                                        ("driving_license"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        (
                                            "transporter_company"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("marital_status"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("nationality"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("pf_no"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("country_of_birth"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("blood_group"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("disability"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("email"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("esic_number"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("emergency_number"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("account_name"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("account_number"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("ifsc_code"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("bank_name"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("branch_name"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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

                                        ("account_type"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
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
                                              .bodyText1!
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
          // todo: calendar carousal
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   child: CalendarCarousel<Event>(
          //     onCalendarChanged: (dateTime) {
          //       logPrint.w("CalendarChanged: $dateTime");
          //       gateStore
          //           .getPersonListByDateRange(
          //           personModel!.id,
          //           DateTime(dateTime.year, dateTime.month, 1),
          //           DateTime(dateTime.year, dateTime.month + 1, 0))
          //           .then((value) => gateTransactions = value);
          //     },
          //     dayPadding: 4,
          //     weekendTextStyle: const TextStyle(
          //       color: Colors.black,
          //     ),
          //     onDayPressed: (day, event) {
          //       // print
          //       List<GateTransactionModel> gateTrxnList = gateTransactions
          //           .where((element) =>
          //       DateTime(
          //           element.createdDate.year,
          //           element.createdDate.month,
          //           element.createdDate.day) ==
          //           day)
          //           .toList();
          //       if (gateTrxnList?.isNotEmpty ?? false) {
          //         showModalBottomSheet(
          //             context: context,
          //             backgroundColor: Colors.transparent,
          //             builder: (context) {
          //               return Card(
          //                 shape: const RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.only(
          //                         topLeft: Radius.circular(12),
          //                         topRight: Radius.circular(12))),
          //                 margin: const EdgeInsets.all(0),
          //                 child: Container(
          //                     padding: const EdgeInsets.all(12),
          //                     child: Column(children: [
          //                       Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 0),
          //                         child: Row(
          //                           children: [
          //                             Expanded(
          //                               child: Text(
          //                                   DateFormat("dd-MMM-yyyy")
          //                                       .format(day),
          //                                   style: Theme.of(context)
          //                                       .textTheme
          //                                       .subtitle1!
          //                                       .copyWith(
          //                                       fontWeight:
          //                                       FontWeight.bold,
          //                                       color: Colors.black)),
          //                             ),
          //                             IconButton(
          //                               icon: const Icon(Icons.close),
          //                               onPressed: () {
          //                                 Navigator.of(context).pop();
          //                               },
          //                             )
          //                           ],
          //                         ),
          //                       ),
          //                       const SizedBox(height: 8),
          //                       Expanded(
          //                         child: ListView.builder(
          //                           itemCount: gateTrxnList.length,
          //                           itemBuilder: (context, pos) {
          //                             return gateTrxnList[pos]
          //                                 .getTransactionListItem(context);
          //                           },
          //                         ),
          //                       )
          //                     ])),
          //               );
          //             });
          //       }
          //     },
          //     thisMonthDayBorderColor: Colors.grey,
          //     customDayBuilder: (
          //         bool isSelectable,
          //         int index,
          //         bool isSelectedDay,
          //         bool isToday,
          //         bool isPrevMonthDay,
          //         TextStyle textStyle,
          //         bool isNextMonthDay,
          //         bool isThisMonthDay,
          //         DateTime day,
          //         ) {
          //       if (gateTransactions?.any((element) =>
          //       DateTime(
          //           element.createdDate.year,
          //           element.createdDate.month,
          //           element.createdDate.day) ==
          //           day) ??
          //           false) {
          //         return Container(
          //           alignment: Alignment.center,
          //           child: Text(day.day.toString(),
          //               style: textStyle.copyWith(color: Colors.white)),
          //           decoration: const BoxDecoration(
          //               color: Colors.green, shape: BoxShape.circle),
          //         );
          //       }
          //       return null;
          //     },
          //     weekFormat: false,
          //     daysHaveCircularBorder: null,
          //     todayButtonColor: Colors.transparent,
          //     todayTextStyle: const TextStyle(color: Colors.black),
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: VisibilityExtended(
        visible: true,
        // GlobalData().currentRoleMapping != null &&
        //         GlobalData()
        //                 .currentRoleMapping
        //                 .roleStructure
        //                 .modulePermissions
        //                 .gmsPerson
        //                 .edit ==
        //             1
        //     ? true
        //     : false,

        child: BottomButtonsContainer(
          children: [
            appUserDetailsModel != null
                ? GradientButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    "/admin/gms/person/modifyrole",
                    arguments: {"personId": appUserDetailsModel?.id});
              },
              child: const Text(("modify_role")),
            )
                : GradientButton(
              onPressed: () async {
                appUserDetailsModel =
                await authStore.createAppUserWithoutMapping(
                  personModel?.mobileNo,
                  personModel?.fullName,
                  personModel?.employee?.personalDetail?.email,
                  'UserRole.none',
                );
                setState(() {});
              },
              child: const Text(("generate_app_login")),
            )
          ],
        ),
      ),
    );
  }
}




