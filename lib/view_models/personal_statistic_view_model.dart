import 'package:flutter/material.dart';
import 'package:spending_app/models/expense.dart';
import 'package:spending_app/models/group.dart';
import 'package:spending_app/repositories/global_repo.dart';
import 'package:spending_app/utils/enums/type_bill_enum.dart';
import 'package:spending_app/utils/utils.dart';

class PersonalStatisticViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.instance;
  double? spentMoney;
  Map<TypeBill, Map<String, double>> typeRatio = {};
  Map<Group, Map<String, double>> groupRadio = {};
  DateTime? lastUpdate;

  void update() {
    lastUpdate = DateTime.now();
    notifyListeners();
  }

  Future<void> getSpentMoneyInCurrentMonth(List<dynamic> groupsIdList, String currentUserId) async {
    double money = 0;
    Map<TypeBill, double> typeTmp = {};
    Map<Group, double> groupTmp = {};

    List<Group> groups = await globalRepo.getAllGroupsByIdList(groupsIdList);

    DateTime dateTime = DateTime.now();
    for(var group in groups) {
      double moneyInGroup = 0;

      List<Expense> expenses = await globalRepo.getAllExpensesInMonth(group.id, formatDateCollection(dateTime));

      for (var expense in expenses) {
        if (expense.membersIdList.contains(currentUserId)) {
          var type = expense.type;
          var expenseMoney = expense.price/expense.membersIdList.length;
          if (typeTmp[type] == null) {
            typeTmp[type] = 0;
          }
          typeTmp[type] = typeTmp[type]! + expenseMoney;
          money += expenseMoney;
          moneyInGroup += expenseMoney;
        }
      }

      if (moneyInGroup != 0) {
        groupTmp[group] = moneyInGroup;
      }
    }

    spentMoney = money;

    Map<TypeBill, Map<String, double>> typeTmp2 = {};
    typeTmp.forEach((key, value) {
      typeTmp2[key] = {
        'value': value,
        'percent': value/money*100,
      };
    });
    typeRatio = typeTmp2;

    Map<Group, Map<String, double>> groupTmp2 = {};
    groupTmp.forEach((key, value) {
      groupTmp2[key] = {
        'value': value,
        'percent': value/money*100,
      };
    });
    groupRadio = groupTmp2;
    notifyListeners();
  }

  // Future<void> getRatioOfExpense(List<dynamic> groupsIdList, String currentUserId) async {
  //   Map<TypeBill, double> typeTmp = {};
  //   Map<String, double> groupTmp = {};
  //
  //   List<Group> groups = await globalRepo.getAllGroupsByIdList(groupsIdList);
  //
  //   DateTime dateTime = DateTime.now();
  //   for(var group in groups) {
  //     List<Expense> expenses = await globalRepo.getAllExpensesInMonth(group.id, formatDateCollection(dateTime));
  //     for (var expense in expenses) {
  //       if (expense.membersIdList.contains(currentUserId)) {
  //         var type = expense.type;
  //         var money = expense.price/expense.membersIdList.length;
  //         if (typeTmp[type] == null) {
  //           typeTmp[type] = 0;
  //         }
  //         typeTmp[type] = typeTmp[type]! + money;
  //       }
  //     }
  //   }
  //   typeTmp.forEach((key, value) {
  //     typeTmp[key] = value/spentMoney!*100;
  //   });
  //   print(typeTmp);
  //   typeRatio = typeTmp;
  //   notifyListeners();
  // }
}