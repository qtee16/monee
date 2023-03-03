import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/exception.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/repositories/firebase_repos/member_repo.dart';
import 'package:uuid/uuid.dart';

import '../models/expense.dart';
import '../models/group.dart';
import 'firebase_repos/expense_repo.dart';
import 'firebase_repos/group_repo.dart';
import 'firebase_repos/upload_repo.dart';


class GlobalRepo {
  static final GlobalRepo _this = GlobalRepo._getInstance();

  static GlobalRepo get instance => _this;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  late final MemberRepo memberRepo;
  late final GroupRepo groupRepo;
  late final UploadRepo uploadRepo;
  late final ExpenseRepo expenseRepo;

  GlobalRepo._getInstance() {
    memberRepo = MemberRepo(firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore);
    groupRepo = GroupRepo(firebaseFirestore: firebaseFirestore);
    uploadRepo = UploadRepo(storage: storage);
    expenseRepo = ExpenseRepo(firebaseFirestore: firebaseFirestore);
  }

  //MemberRepo
  String? getCurrentUserId() {
    return memberRepo.getCurrentUserId();
  }

  getUserCredential() {
    return memberRepo.getUserCredential();
  }

  Future<Member?> getCurrentUser() async {
    return await memberRepo.getCurrentUser();
  }

  Future<Member> getUserById(String userId) async {
    return await memberRepo.getUserById(userId);
  }

  Future<List<Member>> getAllUsersByIdsList(List<dynamic> usersIdList) async {
    return await memberRepo.getAllUsersByIdsList(usersIdList);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamCurrentUser() {
    return memberRepo.getStreamCurrentUser();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUserById(String userId) {
    return memberRepo.getStreamUserById(userId);
  }

  Future<void> signInWithEmail(String email, String password) async {
    await memberRepo.signInWithEmail(email, password);
  }

  Future<Member?> signUpWithEmail(String firstName, String lastName, String email, String password) async {
    return await memberRepo.signUpWithEmail(firstName, lastName, email, password);
  }

  Future<void> signOut() async {
    await memberRepo.signOut();
  }

  Future<void> addNewGroupToGroupsIdList(String userId, String groupId) async {
    await memberRepo.addNewGroupToGroupsIdList(userId, groupId);
  }

  Future<void> removeRequestFromRequestsIdList(String userId, String groupId) async {
    await memberRepo.removeRequestFromRequestsIdList(userId, groupId);
  }

  Future<void> updateUserImageURL(String userId, File imageFile) async {
    String imageURL = await uploadImage(userId, imageFile, userId, ConstantStrings.dbString.usersCollection);
    await memberRepo.updateUserImageURL(userId, imageURL);
  }

  Future<void> updateFirstName(String userId, String firstName) async {
    await memberRepo.updateFirstName(userId, firstName);
  }

  Future<void> updateLastName(String userId, String lastName) async {
    await memberRepo.updateLastName(userId, lastName);
  }

  Future<void> changePassword(String password) async {
    await memberRepo.changePassword(password);
  }


  //Group Repo
  Future<void> createNewGroup(File imageFile, String groupName,) async {
    var id = const Uuid().v1();
    String imageURL = await uploadImage(id, imageFile, id, ConstantStrings.dbString.groupsCollection);
    String? userId = getCurrentUserId();
    await groupRepo.createNewGroup(id, groupName, imageURL, [userId], [userId]);
    await addNewGroupToGroupsIdList(userId!, id);
  }

  Future<void> updateGroupImageURL(String groupId, File imageFile) async {
    String imageURL = await uploadImage(groupId, imageFile, groupId, ConstantStrings.dbString.groupsCollection);
    await groupRepo.updateGroupImageURL(groupId, imageURL);
  }

  Future<void> updateGroupName(String groupId, String name) async {
    await groupRepo.updateGroupName(groupId, name);
  }

  Future<Group> getGroupById(String id) async {
    return await groupRepo.getGroupById(id);
  }

  Future<List<Group>> getAllGroupsByIdList(List<dynamic> groupsIdList) async {
    return await groupRepo.getAllGroupsByIdList(groupsIdList);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamGroupById(String groupId) {
    return groupRepo.getStreamGroupById(groupId);
  }

  Future<void> requestToJoinGroup(String groupId) async {
    var userId = getCurrentUserId()!;
    await groupRepo.requestToJoinGroup(userId, groupId);
    await memberRepo.addNewRequestToRequestsIdList(groupId);
  }

  Future<void> removeRequestToJoinGroup(String userId, String groupId) async {
    await groupRepo.removeRequestToJoinGroup(userId, groupId);
    await removeRequestFromRequestsIdList(userId, groupId);
  }

  Future<void> acceptRequestToJoinGroup(String userId, String groupId) async {
    await groupRepo.joinGroup(userId, groupId);
    await addNewGroupToGroupsIdList(userId, groupId);
    await removeRequestToJoinGroup(userId, groupId);
  }

  Future<void> removeMemberFromGroup(String userId, String groupId) async {
    var group = await getGroupById(groupId);
    if (group.ownersIdList.contains(userId) && group.ownersIdList.length == 1) {
      throw YouAreOnlyOwnerOfGroupException();
    } else {
      await memberRepo.removeGroupFromGroupsIdList(userId, groupId);
      await groupRepo.removeMemberFromGroup(userId, groupId);
    }
  }

  Future<void> acceptAllRequest(List<dynamic> usersIdList, String groupId) async {
    for (var userId in usersIdList) {
      await acceptRequestToJoinGroup(userId, groupId);
    }
  }

  Future<void> removeAllRequest(List<dynamic> usersIdList, String groupId) async {
    for (var userId in usersIdList) {
      await removeRequestToJoinGroup(userId, groupId);
    }
  }

  Future<void> deleteGroup(String groupId) async {
    Group group = await getGroupById(groupId);
    for (var userId in group.membersIdList) {
      await memberRepo.removeGroupFromGroupsIdList(userId, groupId);
    }
    await groupRepo.deleteGroup(groupId);
  }

  Future<void> addNewOwnerForGroup(String groupId, String userId) async {
    await groupRepo.addNewOwnerForGroup(groupId, userId);
  }

  Future<void> removeAnOwnerFromGroup(String groupId, String userId) async {
    await groupRepo.removeAnOwnerFromGroup(groupId, userId);
  }

  // ExpenseRepo
  Future<void> createNewExpense(Expense expense) async {
    await expenseRepo.createNewExpense(expense);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllExpensesInMonthStream(
      String groupId, String date) {
    return expenseRepo.getAllExpensesInMonthStream(groupId, date);
  }

  Future<void> updateExpense(Expense expense, {Expense? oldExpense}) async {
    await expenseRepo.updateExpense(expense, oldExpense: oldExpense);
  }

  Future<void> deleteExpense(Expense expense) async {
    await expenseRepo.deleteExpense(expense);
  }

  int getTotalMoney(List<Expense> expenses) {
    return expenseRepo.getTotalMoney(expenses);
  }

  List<Map<String, dynamic>> calculateMoneyOfMonth(List<Expense> expenses) {
    return expenseRepo.calculateMoneyOfMonth(expenses);
  }

  Future<List<Expense>> getAllExpensesInMonth(
      String groupId, String date) async {
    return await expenseRepo.getAllExpensesInMonth(groupId, date);
  }


  // UploadRepo
  Future<String> uploadImage(String id, File imageFile, String imageName, String type) async {
    return await uploadRepo.uploadImage(id, imageFile, imageName, type);
  }



  getData(groupId) async{
    await groupRepo.getData(groupId);
  }
}