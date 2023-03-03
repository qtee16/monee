import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/repositories/global_repo.dart';

class MemberViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.instance;

  bool isSignIn = false;

  Member? currentUser;

  init() async {
    var currentUserId = globalRepo.getCurrentUserId();
    if (currentUserId != null) {
      isSignIn = true;
      // notifyListeners();
    }
    Member? user = await globalRepo.getCurrentUser();
    if (user != null) {
      setCurrentUser(user);
    }
  }

  User getUserCredential() {
    return globalRepo.getUserCredential();
  }

  setCurrentUser(Member? newUser) {
    currentUser = newUser;
    notifyListeners();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamCurrentUser() {
    return globalRepo.getStreamCurrentUser();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUserById(String userId) {
    return globalRepo.getStreamUserById(userId);
  }

  Future<Member> getUserById(String userId) async {
    return await globalRepo.getUserById(userId);
  }

  Future<void> signInWithEmail(String email, String password) async {
    await globalRepo.signInWithEmail(email, password);
    Member? user = await globalRepo.getCurrentUser();
    setCurrentUser(user);
  }

  Future<Member?> signUpWithEmail(String firstName, String lastName, String email, String password) async {
    Member? user = await globalRepo.signUpWithEmail(firstName, lastName, email, password);
    setCurrentUser(user);
    return user;
  }

  Future<void> signOut() async {
    await globalRepo.signOut();
    setCurrentUser(null);
  }

  Future<List<Member>> getAllUsersByIdsList(List<dynamic> usersIdList) async {
    return await globalRepo.getAllUsersByIdsList(usersIdList);
  }

  Future<void> changePassword(String password) async {
    await globalRepo.changePassword(password);
  }
}