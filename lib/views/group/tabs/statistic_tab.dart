import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:spending_app/constants.dart';
import 'package:spending_app/models/expense.dart';
import 'package:spending_app/models/group.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/view_models/expense_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/statistic_item.dart';

import '../../../utils/utils.dart';
import '../../../widgets/custom_dropdown.dart';

class StatisticTab extends StatefulWidget {
  final Group group;

  const StatisticTab({Key? key, required this.group}) : super(key: key);

  @override
  State<StatisticTab> createState() => _StatisticTabState();
}

class _StatisticTabState extends State<StatisticTab> {
  int selectMonth = DateTime.now().month;
  int selectYear = DateTime.now().year;

  late String dropdownValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: Center(
              child: Text(
                ConstantStrings.appString.statistic,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tháng',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomDropdown(
                    hint: 'Select Item',
                    valueAlignment: Alignment.center,
                    dropdownItems: ConstantDateTime.months,
                    value: selectMonth,
                    onChanged: (dynamic value) {
                      setState(() {
                        selectMonth = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Năm',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomDropdown(
                    hint: 'Select Item',
                    valueAlignment: Alignment.center,
                    dropdownItems: ConstantDateTime.years,
                    value: selectYear,
                    onChanged: (dynamic value) {
                      setState(() {
                        selectYear = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Consumer<ExpenseViewModel>(
                builder: (context, model, child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: model.getAllExpensesInMonthStream(
                          widget.group.id, "$selectMonth-$selectYear"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs.toList();
                          List<Expense> expensesList = data
                              .map((e) => Expense.fromJson(e.data()))
                              .toList();
                          List<Map<String, dynamic>> statistic =
                              model.calculateMoneyOfMonth(expensesList);

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ConstantStrings.appString.totalMoney,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  Text(
                                    formatter.format(
                                        model.getTotalMoney(expensesList)),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Column(
                                children:
                                    List.generate(statistic.length, (index) {
                                  var item = statistic[index];
                                  return Column(
                                    children: [
                                      StreamBuilder<
                                          DocumentSnapshot<Map<String, dynamic>>>(
                                        stream: Provider.of<MemberViewModel>(
                                                context,
                                                listen: false)
                                            .getStreamUserById(item['id']),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var json = snapshot.data!.data();
                                            var user = Member.fromJson(json!);
                                            return StatisticItem(
                                              imageURL: user.imageURL,
                                              name: user.firstName,
                                              spent: item['money']['spent'].round(),
                                              debt: item['money']['debt'].round(),
                                            );
                                          }
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!
                                                .withOpacity(0.6),
                                            highlightColor: Colors.grey[100]!
                                                .withOpacity(0.6),
                                            enabled: true,
                                            child: Container(
                                              width: double.infinity,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: List.generate(
                            3,
                            (index) {
                              return Column(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!.withOpacity(0.6),
                                    highlightColor:
                                        Colors.grey[100]!.withOpacity(0.6),
                                    enabled: true,
                                    child: Container(
                                      width: double.infinity,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
