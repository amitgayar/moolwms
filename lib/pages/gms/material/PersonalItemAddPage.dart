// import 'package:flutter/material.dart';
// import 'package:moolwms/model/MaterialModel.dart';
// import 'package:moolwms/model/OptionModel.dart';
// import 'package:moolwms/utils/AppLocalizations.dart';
// import 'package:moolwms/widgets/bottom_button_container.dart';
// import 'package:moolwms/widgets/custom_form_fields.dart';
// import 'package:moolwms/widgets/gradient_button.dart';
// import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
//
// class PersonalItemAddPage extends StatefulWidget {
//   PersonalMaterialItemModel item;
//   PersonalItemAddPage(dynamic args) {
//     if (args is Map) {
//       item = args['item'];
//     }
//   }
//
//   @override
//   _PersonalItemAddPageState createState() => _PersonalItemAddPageState();
// }
//
// class _PersonalItemAddPageState extends State<PersonalItemAddPage> {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   PersonalMaterialItemModel item;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.item != null) {
//       item = widget.item;
//     } else {
//       item = PersonalMaterialItemModel();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context).translate("item")),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 initialValue: item.category,
//                 onSaved: (val) => item.category = val,
//                 validator: (val) {
//                   if (val.isEmpty) {
//                     return AppLocalizations.of(context)
//                         .translate("enter_product_category");
//                   }
//                   return null;
//                 },
//                 decoration: DecorationUtils.getTextFieldDecoration(
//                   context,
//                   labelText: AppLocalizations.of(context)
//                       .translate("product_category"),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 initialValue: item.name,
//                 onSaved: (val) => item.name = val,
//                 validator: (val) {
//                   if (val.isEmpty) {
//                     return AppLocalizations.of(context)
//                         .translate("enter_product_name");
//                   }
//                   return null;
//                 },
//                 decoration: DecorationUtils.getTextFieldDecoration(
//                   context,
//                   labelText:
//                       AppLocalizations.of(context).translate("product_name"),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 initialValue: item?.quantity?.toString(),
//                 onSaved: (val) => item.quantity = double.parse(val),
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                 validator: (val) {
//                   if (val.isEmpty) {
//                     return AppLocalizations.of(context)
//                         .translate("enter_quantity");
//                   }
//                   return null;
//                 },
//                 decoration: DecorationUtils.getTextFieldDecoration(
//                   context,
//                   labelText: AppLocalizations.of(context).translate("quantity"),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 initialValue: item.source,
//                 onSaved: (val) => item.source = val,
//                 validator: (val) {
//                   if (val.isEmpty) {
//                     return AppLocalizations.of(context)
//                         .translate("enter_source");
//                   }
//                   return null;
//                 },
//                 decoration: DecorationUtils.getTextFieldDecoration(
//                   context,
//                   labelText: AppLocalizations.of(context).translate("source"),
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomButtonsContainer(
//         children: [
//           FlatButton(
//             child: Text(AppLocalizations.of(context).translate('back')),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           const SizedBox(width: 8),
//           GradientButton(
//             onPressed: () async {
//               if (_formKey.currentState.validate()) {
//                 _formKey.currentState.save();
//                 Navigator.of(context).pop(item);
//               }
//             },
//             child: Text(AppLocalizations.of(context)
//                 .translate(widget.item != null ? "edit_item" : "add_item")),
//           ),
//         ],
//       ),
//     );
//   }
// }
