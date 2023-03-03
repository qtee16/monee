import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/models/expense.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/utils/enums/type_bill_enum.dart';
import 'package:spending_app/view_models/expense_view_model.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/confirm_dialog.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/custom_text_field.dart';
import 'package:spending_app/widgets/general_header.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../models/group.dart';
import '../../models/member.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/multi_select.dart';

class CreateOrUpdateExpenseScreen extends StatefulWidget {
  final Group group;
  final Expense? expense;

  const CreateOrUpdateExpenseScreen({Key? key, required this.group, this.expense})
      : super(key: key);

  @override
  State<CreateOrUpdateExpenseScreen> createState() => _CreateOrUpdateExpenseScreenState();
}

class _CreateOrUpdateExpenseScreenState extends State<CreateOrUpdateExpenseScreen> {
  late bool isCreateNewExpense;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController expenseNameController;
  late TextEditingController priceController;
  late TextEditingController dateController;

  TypeBill? selectTypeBill;

  List<Member> _selectedMembers = [];

  void _showMultiSelect(List<Member> members, ExpenseViewModel model) async {
    final List<Member>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
            title: ConstantStrings.appString.selectMember, items: members);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedMembers = results;
      });
      model.changeContent();
    }
  }

  @override
  void initState() {
    isCreateNewExpense = widget.expense == null;
    expenseNameController = TextEditingController();
    priceController = TextEditingController();
    dateController = TextEditingController();
    if (!isCreateNewExpense) {
      expenseNameController.text = widget.expense!.name;
      priceController.text = widget.expense!.price.toString();
      dateController.text = formatDate(widget.expense!.date);
      selectTypeBill = widget.expense!.type;
      () async {
        var tmp = await Provider.of<MemberViewModel>(context, listen: false)
            .getAllUsersByIdsList(widget.expense!.membersIdList);
        setState(() {
          _selectedMembers = tmp;
        });
      }();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseViewModel>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (model.isChanged) {
              showConfirmDialog(
                context: context,
                title: ConstantStrings.appString.wantToExit,
                content: ConstantStrings.appString.wantToExitContent,
                onConfirm: () {
                  model.reset();
                  NavigationService().pop();
                  // NavigationService().pop();
                  return true;
                },
                onCancel: () {
                  // NavigationService().pop();
                  return false;
                }
              );
            }
            return true;
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GeneralHeader(
                          title: isCreateNewExpense
                              ? ConstantStrings.appString.createNewExpense
                              : ConstantStrings.appString.editExpense,
                          onTap: () {
                            if (model.isChanged) {
                              showConfirmDialog(
                                  context: context,
                                  title: ConstantStrings.appString.wantToExit,
                                  content: ConstantStrings.appString.wantToExitContent,
                                  onConfirm: () {
                                    model.reset();
                                    NavigationService().pop();
                                  },
                              );
                            } else {
                              NavigationService().pop();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomTextField(
                          title: ConstantStrings.appString.expenseName,
                          hint: ConstantStrings.appString.inputExpenseName,
                          controller: expenseNameController,
                          onChanged: (value) {
                            model.changeContent();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ConstantStrings
                                  .appString.warningFillFullText;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          title: ConstantStrings.appString.price,
                          hint: ConstantStrings.appString.inputPrice,
                          controller: priceController,
                          textInputType: TextInputType.number,
                          onChanged: (value) {
                            model.changeContent();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ConstantStrings
                                  .appString.warningFillFullText;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          title: ConstantStrings.appString.expenseDate,
                          hint: ConstantStrings.appString.inputExpenseDate,
                          controller: dateController,
                          readOnly: true,
                          suffixIcon: GestureDetector(
                              onTap: (() => selectDate(context, (date) {
                                    String strDate =
                                        '${date.day}/${date.month}/${date.year}';
                                    dateController.text = strDate;
                                    model.changeContent();
                                  })),
                              child: const Icon(Icons.calendar_month_outlined)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ConstantStrings
                                  .appString.warningFillFullText;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ConstantStrings.appString.type,
                              style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            CustomDropdown<TypeBill>(
                              buttonHeight: 48,
                              buttonWidth: double.infinity,
                              dropdownWidth:
                                  MediaQuery.of(context).size.width - 32,
                              hint: 'Chọn loại chi tiêu',
                              valueAlignment: Alignment.center,
                              dropdownItems: TypeBill.values,
                              value: selectTypeBill,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectTypeBill = value;
                                });
                                model.changeContent();
                              },
                              items: TypeBill.values
                                  .map((item) => DropdownMenuItem<TypeBill>(
                                        value: item,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.toStringValue(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              itemHeight: 48,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<Group>(
                          stream: Provider.of<GroupViewModel>(context,
                                  listen: false)
                              .getStreamGroupById(widget.group.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var group = snapshot.data!;
                              return FutureBuilder<List<Member>>(
                                future: Provider.of<MemberViewModel>(context,
                                        listen: false)
                                    .getAllUsersByIdsList(group.membersIdList),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var members = snapshot.data!;
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      onPressed: () {
                                        _showMultiSelect(members, model);
                                      },
                                      child: Text(ConstantStrings.appString.selectMember),
                                    );
                                  }
                                  return const CircularProgressIndicator();
                                },
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                        const Divider(
                          height: 30,
                        ),
                        // display selected items
                        Wrap(
                          children: _selectedMembers
                              .map((e) => Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 4, right: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.purpleStartLinearColor,
                                          AppColors.purpleEndLinearColor,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      e.firstName,
                                      style: const TextStyle(
                                          color: AppColors.whiteColor),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 40),
                        CustomButton(
                          width: double.infinity,
                          height: 48,
                          title: ConstantStrings.appString.confirm,
                          onTap: () async {
                            _processCreateOrUpdate(model);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _processCreateOrUpdate(ExpenseViewModel model) async {
    if (_formKey.currentState!.validate()) {
      if (selectTypeBill != null) {
        if (_selectedMembers.isNotEmpty) {
          if (isCreateNewExpense) {
            String name = expenseNameController.text.trim();
            int price = int.parse(priceController.text.trim());
            String strDate = dateController.text.trim();

            var id = const Uuid().v1();
            var ownerId = Provider.of<MemberViewModel>(context, listen: false).currentUser!.id;
            DateTime date = DateFormat("dd/MM/yyyy").parse(strDate);
            Expense expense = Expense(
              id: id,
              ownerId: ownerId,
              groupId: widget.group.id,
              name: name,
              price: price,
              date: date,
              type: selectTypeBill!,
              membersIdList: _selectedMembers
                  .map((e) => e.id)
                  .toList(),
            );
            showAppLoading(context);
            await model.createNewExpense(expense);
            NavigationService().pop();
            AppToaster.showToast(
              context: context,
              msg: ConstantStrings
                  .appString.createExpenseSuccess,
              type: AppToasterType.success,
            );
            model.reset();
            NavigationService().pop();
          } else {
            if (model.isChanged) {
              String name = expenseNameController.text.trim();
              int price = int.parse(priceController.text.trim());
              String strDate = dateController.text.trim();
              DateTime date = DateFormat("dd/MM/yyyy").parse(strDate);
              String oldDateCollection = formatDateCollection(widget.expense!.date);
              String dateCollection = formatDateCollection(date);
              Expense expense = Expense(
                id: widget.expense!.id,
                ownerId: widget.expense!.ownerId,
                groupId: widget.group.id,
                name: name,
                price: price,
                date: date,
                type: selectTypeBill!,
                membersIdList: _selectedMembers
                    .map((e) => e.id)
                    .toList(),
              );
              showAppLoading(context);
              if (oldDateCollection == dateCollection) {
                await model.updateExpense(expense);
              } else {
                await model.updateExpense(expense, oldExpense: widget.expense);
              }
              NavigationService().pop();
              AppToaster.showToast(
                context: context,
                msg: ConstantStrings
                    .appString.editExpenseSuccess,
                type: AppToasterType.success,
              );
              model.reset();
              NavigationService().pop();
            } else {
              AppToaster.showToast(
                context: context,
                msg: ConstantStrings
                    .appString.notChangedInfoYet,
                type: AppToasterType.warning,
              );
            }
          }

        } else {
          AppToaster.showToast(
            context: context,
            msg: ConstantStrings.appString.mustSelectMember,
            type: AppToasterType.warning,
          );
        }
      } else {
        AppToaster.showToast(
          context: context,
          msg: ConstantStrings.appString.mustSelectType,
          type: AppToasterType.warning,
        );
      }
    }
  }
}

Future<void> selectDate(BuildContext context, Function setDate) async {
  DateTime selectedDate = DateTime.now();
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) {
    setDate(picked);
  }
}
