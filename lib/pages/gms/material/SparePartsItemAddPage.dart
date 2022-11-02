import 'package:flutter/material.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';

class SparePartsItemAddPage extends StatefulWidget {
  SparePartsItemModel item;
  SparePartsItemAddPage(dynamic args) {
    if (args is Map) {
      item = args['item'];
    }
  }

  @override
  _SparePartsItemAddPageState createState() => _SparePartsItemAddPageState();
}

class _SparePartsItemAddPageState extends State<SparePartsItemAddPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SparePartsItemModel item;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      item = widget.item;
    } else {
      item = SparePartsItemModel();
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
                initialValue: item.name,
                onSaved: (val) => item.name = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context).translate("enter_name");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("name"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item?.quantity?.toString(),
                onSaved: (val) => item.quantity = double.parse(val),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_quantity");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("quantity"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item.category,
                onSaved: (val) => item.category = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_category");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("category"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item.purchaseInvoice,
                onSaved: (val) => item.purchaseInvoice = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_purchase_invoice");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context)
                      .translate("purchase_invoice"),
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
