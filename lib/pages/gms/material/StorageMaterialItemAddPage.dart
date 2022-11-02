import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:moolwms/api/CustomerAPIs.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/CategoryModel.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/model/MoolwmsOrgModel.dart';
import 'package:moolwms/model/OptionModel.dart';
import 'package:moolwms/pages/customer/addProductDialog.dart';
import 'package:moolwms/store/CustomerStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Extensions.dart';
import 'package:moolwms/widgets/BottomButtonsContainer.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
import 'package:moolwms/widgets/EmptyView.dart';

class StorageMaterialItemAddPage extends StatefulWidget {
  StorageMaterialItemModel item;
  MoolwmsOrgModel customer;
  StorageMaterialItemAddPage(dynamic args) {
    if (args is Map) {
      item = args['item'];
      customer = args['customer'];
    }
  }

  @override
  _StorageMaterialItemAddPageState createState() =>
      _StorageMaterialItemAddPageState();
}

class _StorageMaterialItemAddPageState
    extends State<StorageMaterialItemAddPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StorageMaterialItemModel item = StorageMaterialItemModel();
  TextEditingController dopController = TextEditingController();
  TextEditingController doeController = TextEditingController();
  TextEditingController skuController = TextEditingController();

  ///for adding new product
  List<ProductCategory> categoryList;
  List<ProductSubCategory> subCategoryList;
  CustomerStore customerStore = CustomerStore();



  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      item = widget.item;
      dopController = TextEditingController(
          text: DateFormat("dd/MM/yyyy").format(item.productionDate));
      doeController = TextEditingController(
          text: DateFormat("dd/MM/yyyy").format(item.expiryDate));
    } else {
      item = StorageMaterialItemModel();
    }
    initCategoryList();
  }

  initCategoryList() async {
    categoryList = await customerStore.getProductCategoryList();
    subCategoryList = await customerStore.getProductSubCategoryList();
  }


  @override
  void dispose() {
    dopController.dispose();
    doeController.dispose();
    skuController.dispose();
    super.dispose();
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
              DropdownSearch<ProductModel>(
                emptyBuilder: (context) {
                  return const EmptyView();
                },
                showSearchBox: true,
                showSelectedItem: true,
                compareFn: (op1, op2) => op1?.id == op2?.id,
                mode: Mode.BOTTOM_SHEET,
                popupTitle: Container(
                    margin: const EdgeInsets.only(top: 18),
                    padding: const EdgeInsets.only(top: 12, left: 12),
                    child: Text(
                        AppLocalizations.of(context).translate("item_name"))),
                dropdownSearchDecoration:
                    DecorationUtils.getDropDownFieldDecoration(context,
                        labelText: AppLocalizations.of(context)
                            .translate("item_name")),
                onChanged: (val) {
                  item.item = val;
                  item.skuCode = val.sku;
                   skuController.text = val.sku;
                },
                selectedItem: item?.item,
                itemAsString: (op) => op.name,
                autoFocusSearchBox: true,
                onFind: (val) async {
                  return await CustomerAPIs.getProducts(
                      widget.customer.mappingId);
                },
                validator: (val) {
                  if (val == null) {
                    return AppLocalizations.of(context)
                        .translate("select_item");
                  }
                  return null;
                },
                onSaved: (val) => item.item = val,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: skuController,
                initialValue: item.skuCode,
                onSaved: (val) => item.skuCode = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_sku_code");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("sku_code"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item.batchNumber,
                onSaved: (val) => item.batchNumber = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_batch_number");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("batch_number"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item?.weight?.toString(),
                onSaved: (val) => item.weight = double.parse(val),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_weight");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("weight_of_unit"),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                  value: item?.unit ?? null,
                  isExpanded: true,
                  onChanged: (String newValue) {
                    setState(() {
                      item.unit = newValue;
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: [
                    "bags",
                    "boxes",
                    "drums",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child:
                          Text(AppLocalizations.of(context).translate(value)),
                    );
                  }).toList(),
                  iconEnabledColor: ColorConstants.PRIMARY,
                  validator: (val) {
                    if (val.isEmptyOrNull) {
                      return AppLocalizations.of(context)
                          .translate("select_unit");
                    }
                    return null;
                  },
                  decoration: DecorationUtils.getDropDownFieldDecoration(
                      context,
                      labelText:
                          AppLocalizations.of(context).translate("unit"))),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: item?.quantity?.toString(),
                      onSaved: (val) => item.quantity = int.parse(val),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (val) {
                        if (val.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("enter_quantity");
                        }
                        return null;
                      },
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
                        labelText:
                            AppLocalizations.of(context).translate("quantity"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: TextFormField(
                      initialValue: item?.temperature?.toString(),
                      onSaved: (val) => item.temperature = double.parse(val),
                      keyboardType:
                         TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.-]")),],
                      validator: (val) {
                        if (val.isEmpty ) {
                          return AppLocalizations.of(context)
                              .translate("enter_temperature");
                        }
                        return null;
                      },
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
                        labelText: AppLocalizations.of(context)
                            .translate("temperature"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        var selectedDate = await showDatePicker(
                            context: context,
                            initialDate: item?.productionDate ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2099));
                        if (selectedDate != null) {
                          item.productionDate = selectedDate;
                          dopController.text =
                              DateFormat("dd/MM/yyyy").format(selectedDate);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                            controller: dopController,
                            autofocus: false,
                            validator: (val) {
                              if (val.isEmptyOrNull) {
                                return AppLocalizations.of(context)
                                    .translate("select_production_date");
                              }
                              if (item.expiryDate != null &&
                                  item.expiryDate
                                      .difference(item.productionDate)
                                      .isNegative) {
                                return AppLocalizations.of(context).translate(
                                    "production_date_should_be_less_than_expiry_date");
                              }
                              return null;
                            },
                            decoration: DecorationUtils.getTextFieldDecoration(
                              context,
                              labelText: AppLocalizations.of(context)
                                  .translate("production_date"),
                              suffixIcon: const Icon(LineAwesomeIcons.calendar,
                                  color: Colors.grey),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        var selectedDate = await showDatePicker(
                            context: context,
                            initialDate: item?.expiryDate ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2099));
                        if (selectedDate != null) {
                          item.expiryDate = selectedDate;
                          doeController.text =
                              DateFormat("dd/MM/yyyy").format(selectedDate);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                            controller: doeController,
                            autofocus: false,
                            validator: (val) {
                              if (val.isEmptyOrNull) {
                                return AppLocalizations.of(context)
                                    .translate("select_expiry_date");
                              }
                              return null;
                            },
                            decoration: DecorationUtils.getTextFieldDecoration(
                              context,
                              labelText: AppLocalizations.of(context)
                                  .translate("expiry_date"),
                              suffixIcon: const Icon(LineAwesomeIcons.calendar,
                                  color: Colors.grey),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: item.remarks,
                onSaved: (val) => item.remarks = val,
                validator: (val) {
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("remarks"),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  showAddProductDialog(context, ProductModel(),
                      categoryList: categoryList,
                      subCategoryList: subCategoryList,
                      callback: (val){
                        setState(() {
                          /// adding new products to customer api hit
                          val.customerId = widget.customer.mappingId;
                          val.customerMappingId = widget.customer.mappingId;
                          CustomerAPIs.addProduct(val);
                        });
                      }
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.add, color: ColorConstants.PRIMARY),
                    Text(
                      AppLocalizations.of(context)
                          .translate("add_product"),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: ColorConstants.PRIMARY),
                    )
                  ],
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
