import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/indent/indent_details_page.dart';
import 'package:moolwms/pages/indent/apis/indent_apis.dart';
import 'package:moolwms/pages/indent/model/indent_list_model.dart';
import 'package:moolwms/utils/shared_pref_utils.dart';
import 'package:moolwms/widgets/my_toast.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/widgets/circular_indicator.dart';

import 'indent_add_page.dart';

class IndentListPage extends StatefulWidget {
  static const String routeName = "/indent";

  const IndentListPage({super.key});

  @override
  IndentListPageState createState() => IndentListPageState();
}

class IndentListPageState extends State<IndentListPage> {
  IndentListModel? indentModel = IndentListModel.fromJson({});

  @override
  void initState() {
    super.initState();
    getIndentModelFromServer();
  }

  Future<IndentListModel> getIndentModelFromServer() async {
    IndentListModel data = await IndentDataRepository.getIndentsList({
      "locationId": 1
      // PrefData.getPref(PrefData.locationId),
      // "pageNumber":1,
      // "pageSize":4
    });
    indentModel = data;
    logPrint.w("indentModel: \n${indentModel?.toJson()}");
    await Future.delayed(
      const Duration(milliseconds: 0),
    );
    setState(() {});
    return data;
  }

  Future<IndentListModel?> getIndentModel() async {
    return indentModel;
  }

  void deleteIndent(int id) async {
    try {
      var response = await IndentDataRepository.deleteIndentById({
        "indentId": id,
      });
      final meta = response['meta'];
      final message = meta['message'];
      myToast(message);
      if (meta['code'] == 200) {
        indentModel?.data?.indentList
            ?.removeWhere((element) => element?.id == id);
        setState(() {});
      }
    } catch (e) {
      logPrint.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var meta = indentModel?.meta;
    var data = indentModel?.data;


    if (indentModel != null && meta != null) {
      if (meta.code == 200) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'Indent',
                style: TextStyle(color: ColorConstants.primary),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: const <Widget>[
                // IconButton(icon: Icon(Icons.search_rounded,color: Colors.black,),onPressed: (){},)
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
                onPressed: () async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              IndentAddPage(IndentListModelDataIndentList())))
                      .then((value) {
                    if (value != null) {
                      getIndentModelFromServer();
                    }
                  });
                },
                child: const Icon(Icons.add),
              ),
            ),
            body: ((data?.indentList?.length) ?? 0) > 0
                ? ListView.builder(
                    itemCount: data?.indentList?.length,
                    itemBuilder: (context, index) {
                      var indent = data?.indentList?[index];
                      return Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.21,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IndentDetailsPage(indent!)));
                              },
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 5, right: 20, bottom: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  indent?.indentNumber ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF3D9ADE),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  //Icon(Icons.money,color: Colors.black,),
                                                  // Image.asset('assets/images/lake.jpg'),
                                                  Visibility(
                                                    maintainSize: false,
                                                    maintainAnimation: true,
                                                    maintainState: true,
                                                    visible: false,
                                                    child: Column(
                                                      children: [
                                                        (indent?.status ==
                                                                "Pending")
                                                            ? Container(
                                                                width: 12,
                                                                height: 12,
                                                                // child: Icon(CustomIcons.option, size: 20,),
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        0xFFF2DB0E)),
                                                              )
                                                            : Container(
                                                                width: 12,
                                                                height: 12,
                                                                // child: Icon(CustomIcons.option, size: 20,),
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        0xFF31D925)),
                                                              ),
                                                        const SizedBox(
                                                          width: 4.0,
                                                        ),
                                                        Text(
                                                          indent?.status ??
                                                              "N/A",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                  ),

                                                  PopupMenuButton(
                                                      icon: const Icon(
                                                        Icons.more_vert,
                                                      ),
                                                      onSelected:
                                                          (String value) async {
                                                        if (value == "Delete") {
                                                          deleteIndent(
                                                              indent?.id ?? 0);
                                                        } else {
                                                          await Navigator.of(
                                                                  context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      IndentAddPage(
                                                                          indent!)))
                                                              .then((value) {
                                                            if (value != null) {
                                                              getIndentModelFromServer();
                                                            }
                                                          });
                                                        }
                                                      },
                                                      itemBuilder: (context) =>
                                                          <
                                                              PopupMenuEntry<
                                                                  String>>[
                                                            PopupMenuItem(
                                                                value: "Delete",
                                                                child: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                        "Delete"),
                                                                  ],
                                                                )),
                                                            PopupMenuItem(
                                                                value: "Edit",
                                                                child: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .edit,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                        "Edit"),
                                                                  ],
                                                                )),
                                                          ])
                                                  //Image.asset('assets/images/arrow_right.png',width: 15, height: 15),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Indent Type',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    //fontWeight: FontWeight.bold,
                                                    color: Color(0xFF707070),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  indent?.requestType ?? "N/A",
                                                  style: const TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Indent Date',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Color(0xFF707070),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                (indent?.serviceDate ?? "")
                                                    .substring(0, 10),
                                                style: const TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Time Interval',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    //fontWeight: FontWeight.bold,
                                                    color: Color(0xFF707070),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  indent?.serviceSlot ?? "N/A",
                                                  style: const TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'Assigned Dock',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Color(0xFF707070),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                '-',
                                                style: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (index == (data?.indentList?.length ?? 0) - 1)
                            const SizedBox(
                              height: 100,
                            )
                        ],
                      );
                    },
                  )
                : const Center(child: Text("No Indent Found")));
      } else {
        return Scaffold(
          body:
              Center(child: Text("error code: ${meta.code}\n${meta.message}")),
        );
      }
    }
    return const Scaffold(body: CircularProgressIndicatorApp());
  }
}
