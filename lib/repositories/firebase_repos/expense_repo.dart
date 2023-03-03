import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/models/expense.dart';

import '../../utils/utils.dart';

class ExpenseRepo {
  final FirebaseFirestore firebaseFirestore;

  ExpenseRepo({required this.firebaseFirestore});

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllExpensesInMonthStream(
      String groupId, String date) {
    return firebaseFirestore
        .collection(ConstantStrings.dbString.expenseGroupsCollection)
        .doc(groupId)
        .collection(date)
        .orderBy(ConstantStrings.dbString.date, descending: true)
        .snapshots();
  }

  Future<List<Expense>> getAllExpensesInMonth(
      String groupId, String date) async {
    var query = await firebaseFirestore
        .collection(ConstantStrings.dbString.expenseGroupsCollection)
        .doc(groupId)
        .collection(date)
        .get();

    List<Expense> expenses = query.docs.map((e) => Expense.fromJson(e.data())).toList();
    return expenses;
  }

  Future<void> createNewExpense(Expense expense) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.expenseGroupsCollection)
        .doc(expense.groupId)
        .collection(formatDateCollection(expense.date))
        .doc(expense.id)
        .set(expense.toJson());
  }

  Future<void> updateExpense(Expense expense, {Expense? oldExpense}) async {
    if (oldExpense == null) {
      await firebaseFirestore
          .collection(ConstantStrings.dbString.expenseGroupsCollection)
          .doc(expense.groupId)
          .collection(formatDateCollection(expense.date))
          .doc(expense.id)
          .update(expense.toJson());
    } else {
      await createNewExpense(expense);
      await deleteExpense(oldExpense);
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.expenseGroupsCollection)
        .doc(expense.groupId)
        .collection(formatDateCollection(expense.date))
        .doc(expense.id)
        .delete();
  }

  int getTotalMoney(List<Expense> expenses) {
    int totalMoney = 0;
    for (var expense in expenses) {
      totalMoney += expense.price;
    }
    return totalMoney;
  }

  List<Map<String, dynamic>> calculateMoneyOfMonth(List<Expense> expenses) {
    Map<String, Map<String, double>> statistic = {};

    for (var expense in expenses) {
      String ownerId = expense.ownerId;
      List<dynamic> membersId = expense.membersIdList;
      double moneyPerMem = expense.price/membersId.length;
      print(moneyPerMem);
      for (var memberId in membersId) {
        if (statistic[memberId] == null) {
          statistic[memberId] = {
            'spent': 0,
            'debt': 0,
          };
        }
          double spent = statistic[memberId]!['spent']!;
          double debt = statistic[memberId]!['debt']!;

          spent += moneyPerMem;
          statistic[memberId]!['spent'] = spent;

          if (memberId == ownerId) {
            debt += expense.price - moneyPerMem;
          } else {
            debt -= moneyPerMem;
          }
          statistic[memberId]!['debt'] = debt;

      }
    }

    print(statistic);

    List<Map<String, dynamic>> result = [];

    statistic.forEach((id, money) {
      Map<String, dynamic> item = {
        'id': id,
        'money': money,
      };
      result.add(item);
    });

    return result;
  }

}
