import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_app/repositories/global_repo.dart';

import '../models/expense.dart';

class ExpenseViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.instance;

  bool isChanged = false;

  void reset() {
    isChanged = false;
    notifyListeners();
  }

  void changeContent() {
    if (!isChanged) {
      isChanged = true;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllExpensesInMonthStream(
      String groupId, String date) {
    return globalRepo.getAllExpensesInMonthStream(groupId, date);
  }

  Future<void> createNewExpense(Expense expense) async {
    await globalRepo.createNewExpense(expense);
  }

  Future<void> updateExpense(Expense expense, {Expense? oldExpense}) async {
    await globalRepo.updateExpense(expense, oldExpense: oldExpense);
  }

  Future<void> deleteExpense(Expense expense) async {
    await globalRepo.deleteExpense(expense);
  }

  int getTotalMoney(List<Expense> expenses) {
    return globalRepo.getTotalMoney(expenses);
  }

  List<Map<String, dynamic>> calculateMoneyOfMonth(List<Expense> expenses) {
    return globalRepo.calculateMoneyOfMonth(expenses);
  }
}