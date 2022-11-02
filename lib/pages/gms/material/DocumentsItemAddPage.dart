import 'package:flutter/material.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/model/OptionModel.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
import 'package:moolwms/widgets/EmptyView.dart';

class DocumentsItemAddPage extends StatefulWidget {
  DocumentsItemModel item;
  DocumentsItemAddPage(dynamic args) {
    if (args is Map) {
      item = args['item'];
    }
  }

  @override
  _DocumentsItemAddPageState createState() => _DocumentsItemAddPageState();
}

class _DocumentsItemAddPageState extends State<DocumentsItemAddPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DocumentsItemModel item;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      item = widget.item;
    } else {
      item = DocumentsItemModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("item")),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: item.description,
                onSaved: (val) => item.description = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_description");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("description"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item.fileNumber,
                onSaved: (val) => item.fileNumber = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_file_number");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("file_number"),
                ),
              ),
              const SizedBox(height: 24),
              DropdownSearch<String>(
                emptyBuilder: (context) {
                  return const EmptyView();
                },
                showSearchBox: true,
                showSelectedItem: true,
                compareFn: (op1, op2) => op1 == op2,
                mode: Mode.BOTTOM_SHEET,
                popupTitle: Container(
                    margin: const EdgeInsets.only(top: 18),
                    padding: const EdgeInsets.only(top: 12, left: 12),
                    child: Text(AppLocalizations.of(context)
                        .translate("select_document_category"))),
                dropdownSearchDecoration:
                    DecorationUtils.getDropDownFieldDecoration(context,
                        labelText: AppLocalizations.of(context)
                            .translate("document_type")),
                onChanged: (val) => item.category = val,
                selectedItem: item.category,
                autoFocusSearchBox: true,
                onFind: (val) async {
                  var docTypeOptions = await OptionAPIs.getOptions("DOCTYPE");
                  // ignore: prefer_collection_literals
                  List<String> docTypes = List<String>();
                  docTypeOptions
                      .forEach((element) => docTypes.add(element.label));
                  return docTypes;
                },
                validator: (val) {
                  if (val == null) {
                    return AppLocalizations.of(context)
                        .translate("select_document_category");
                  }
                  return null;
                },
                onSaved: (val) => item.category = val,
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item.source,
                onSaved: (val) => item.source = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_source");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("source"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButtonsContainer(
        children: [
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('back')),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          GradientButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.of(context).pop(item);
              }
            },
            child: Text(AppLocalizations.of(context)
                .translate(widget.item != null ? "edit_item" : "add_item")),
          ),
        ],
      ),
    );
  }
}
