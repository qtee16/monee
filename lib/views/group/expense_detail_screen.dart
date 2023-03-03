import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/models/expense.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/utils/enums/type_bill_enum.dart';
import 'package:spending_app/utils/utils.dart';
import 'package:spending_app/view_models/expense_view_model.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/custom_text_field.dart';
import 'package:spending_app/widgets/general_header.dart';
import 'package:spending_app/widgets/shimmer_loading.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../models/group.dart';
import '../../models/member.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/multi_select.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;

  const ExpenseDetailScreen({Key? key, required this.expense})
      : super(key: key);

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController expenseNameController;
  late TextEditingController priceController;
  late TextEditingController dateController;

  TypeBill? selectTypeBill;

  List<Member> _selectedMembers = [];

  void _showMultiSelect(List<Member> members) async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    // final List<String> items = [
    //   'Flutter',
    //   'Node.js',
    //   'React Native',
    //   'Java',
    //   'Docker',
    //   'MySQL'
    // ];

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
    }
  }

  @override
  void initState() {
    expenseNameController = TextEditingController();
    priceController = TextEditingController();
    dateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseViewModel>(
      builder: (context, model, child) {
        return Container(
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
                        title: ConstantStrings.appString.expenseDetail,
                        onTap: () {
                          NavigationService().pop();
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      FutureBuilder<Member>(
                        future: Provider.of<MemberViewModel>(context, listen: false).getUserById(widget.expense.ownerId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Member member = snapshot.data!;
                            return detailItem(ConstantStrings.appString.expenseOwner, member.firstName);
                          }
                          return loadingItem();
                        },
                      ),
                      const SizedBox(height: 40,),
                      detailItem(ConstantStrings.appString.expenseName, widget.expense.name),
                      const SizedBox(height: 40,),
                      detailItem(ConstantStrings.appString.type, widget.expense.type.toStringValue()),
                      const SizedBox(height: 40,),
                      detailItem(ConstantStrings.appString.price, formatter.format(widget.expense.price)),
                      const SizedBox(height: 40,),
                      detailItem(ConstantStrings.appString.expenseDate, formatDate(widget.expense.date)),
                      const SizedBox(height: 40,),
                      FutureBuilder<List<Member>>(
                        future: Provider.of<MemberViewModel>(context, listen: false).getAllUsersByIdsList(widget.expense.membersIdList),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Member> members = snapshot.data!;
                            List<String> names = members.map((e) => e.firstName).toList();
                            return detailItem(ConstantStrings.appString.expenseUser, names.join(', '));
                          }
                          return loadingItem();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loadingItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ShimmerLoading(width: 200, height: 20, border: 4),
        SizedBox(height: 8,),
        ShimmerLoading(width: 200, height: 20, border: 4),
      ],
    );
  }

  Widget detailItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        const SizedBox(height: 8,),
        Text(
          content,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

}
