import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/indent/model/indent_list_model.dart';
import 'package:moolwms/pages/indent/single_full_image.dart';



class IndentDetailsPage extends StatelessWidget {
  const IndentDetailsPage(this.indentListItem, {Key? key}) : super(key: key);

  final IndentListModelDataIndentList? indentListItem;


  @override
  Widget build(BuildContext context) {
    var textTheme  = Theme.of(context).textTheme;
    return   Scaffold(
        appBar: AppBar(
          title: const Text(
            'Indent Details',
            style: TextStyle(color: ColorConstants.primary),
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop(indentListItem);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Container(

                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: (indentListItem?.requestType??"").toLowerCase()=="inward"
                      ? Colors.green[100]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text((indentListItem?.requestType??"").toLowerCase()=="inward"
                            ?
                            ("Inward")
                            :
                            ("Outward"))),

                  ],
                ),
              ),
              const SizedBox(height: 12),
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
                              "Indent Service Date",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child:
                              (indentListItem?.serviceDate??"").isNotEmpty?
                              Text(
                                indentListItem!.serviceDate!.substring(0,10),
                                style: textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ):const Text("")

                          )
                        ],
                      ),
                      const Divider(),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Service Slot",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                indentListItem?.serviceSlot??"",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),

                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Driver Mobile No",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                indentListItem?.driverMobileNumber??"",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Vehicle No",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                indentListItem?.vehicleNumber??"",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Booked Dock",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                "-",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Status",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                indentListItem?.status??"",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "eWayBill",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child:
                              (indentListItem?.ewayDocUrl??"").isEmpty?
                              const Text("-"):
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext
                                          context) =>
                                              SingleFullImage(
                                                  indentListItem?.ewayDocUrl,
                                                  "eWayBill")));
                                },
                                child: const Text(
                                  "Click to Preview",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.buttonLight,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Invoice /STN",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child:  (indentListItem?.invoiceDocUrl??"").isEmpty?
                              const Text("-"):
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext
                                          context) =>
                                              SingleFullImage(
                                                  indentListItem?.invoiceDocUrl,
                                                  "Invoice /STN")));
                                },
                                child: const Text(
                                  "Click to Preview",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.buttonLight,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Other Doc.",
                              style: textTheme.bodyText1!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: (indentListItem?.otherDocUrl??"").isEmpty?
                              const Text("-"):
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext
                                          context) =>
                                              SingleFullImage(
                                                  indentListItem?.otherDocUrl,
                                                  "Other Doc.")));
                                },
                                child: const Text(
                                  "Click to Preview",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.buttonLight,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 64),
            ],
          ),
        ),

      );

  }
}
