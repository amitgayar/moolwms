import 'package:flutter/material.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/BottomButtonsContainer.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';

class DieselItemAddPage extends StatefulWidget {
   DieselItemModel item;
  DieselItemAddPage(dynamic args, {Key key}) : super(key: key) {
    if (args is Map) {
      item = args['item'];
    }
  }

  @override
  _DieselItemAddPageState createState() => _DieselItemAddPageState();
}

class _DieselItemAddPageState extends State<DieselItemAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DieselItemModel item;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      item = widget.item;
    } else {
      item = DieselItemModel();
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
                initialValue: item.billNumber,
                onSaved: (val) => item.billNumber = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_bill_number");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("bill_number"),
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
