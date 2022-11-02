import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/model.dart';

class SearchList extends StatelessWidget {
  final List<PersonModel>? personList;
  const SearchList({super.key, this.personList});

  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: personList!.length,
        itemBuilder: (context, index) {
          return Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.of(context).pushNamed("/admin/gms/person/details",
                      arguments: {"person": personList![index]});
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(personList![index].fullName ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: ColorConstants.primary,
                                      fontWeight: FontWeight.w600)),
                          const Spacer(),
                          PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert,
                              ),
                              onSelected: (String value) {
                                if (value.contains("EDIT")) {
                                  Navigator.of(context).pushNamed(
                                      "/admin/gms/person/details",
                                      arguments: {"person": this});
                                } else if (value.contains("SUSPEND")) {
                                  PersonStore().suspendPerson(personList![index].empId);
                                }
                              },
                              itemBuilder: (context) =>
                                  <PopupMenuEntry<String>>[
                                    PopupMenuItem(
                                        value: "EDIT",
                                        child: Row(
                                          children: const [
                                            Icon(Icons.edit),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                ("edit")),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: "SUSPEND",
                                        child: Row(
                                          children: const [
                                            Icon(Icons.delete),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                ("suspend")),
                                          ],
                                        )),
                                  ])
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(

                                      ("mobile_number"),
                                  style: Theme.of(context).textTheme.bodyText1),
                              Text(personList![index].mobileNo.number,
                                  style: Theme.of(context).textTheme.button),
                            ],
                          )),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(

                                      ("person_type"),
                                  style: Theme.of(context).textTheme.bodyText1),
                              Text(personList![index].personType?.label ?? "",
                                  style: Theme.of(context).textTheme.button),
                            ],
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
