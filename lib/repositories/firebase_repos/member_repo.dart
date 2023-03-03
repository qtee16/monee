import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/utils/utils.dart';

import '../../constants.dart';
import '../../exception.dart';

class MemberRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  MemberRepo({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  String? getCurrentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  getUserCredential() {
    return firebaseAuth.currentUser;
  }

  Future<Member?> getCurrentUser() async {
    var currentUserId = getCurrentUserId();
    if (currentUserId != null) {
      var query = await firebaseFirestore
          .collection(ConstantStrings.dbString.usersCollection)
          .doc(getCurrentUserId())
          .get();
      var user = Member.fromJson(query.data()!);
      return user;
    }
    return null;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamCurrentUser() {
    String? id = getCurrentUserId();
    return firebaseFirestore.collection(
        ConstantStrings.dbString.usersCollection).doc(id).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUserById(String userId) {
    return firebaseFirestore.collection(
        ConstantStrings.dbString.usersCollection).doc(userId).snapshots();
  }

  Future<List<Member>> getAllUsersByIdsList(List<dynamic> usersIdList) async {
    List<Member> membersList = [];
    for (var userId in usersIdList) {
      Member user = await getUserById(userId);
      membersList.add(user);
    }
    return membersList;
  }

  Future<Member> getUserById(String userId) async {
    var query = await firebaseFirestore.collection(ConstantStrings.dbString.usersCollection).doc(userId).get();
    var user = Member.fromJson(query.data()!);
    return user;
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  Future<Member?> signUpWithEmail(String firstName, String lastName, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String hashPassword = encrypt(password);
      var user = Member(
        id: userCredential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        hashPassword: hashPassword,
        groupsIdList: [],
        requestGroupsIdList: [],
      );
      await updateNewUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
    return null;
  }

  signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> updateNewUser(Member user) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.usersCollection)
        .doc(user.id)
        .set(user.toJson());
  }

  Future<void> addNewGroupToGroupsIdList(String userId, String groupId) async {
    Member? user = await getUserById(userId);
    var groupsIdList = user.groupsIdList;
    if (!groupsIdList.contains(groupId)) {
      groupsIdList.add(groupId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.usersCollection)
          .doc(user.id)
          .update({ConstantStrings.dbString.groupsIdList: groupsIdList});
    } else {
      throw JoinedOrRequestedException();
    }
  }

  Future<void> removeGroupFromGroupsIdList(String userId, String groupId) async {
    Member? user = await getUserById(userId);
    var groupsIdList = user.groupsIdList;
    if (groupsIdList.contains(groupId)) {
      groupsIdList.remove(groupId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.usersCollection)
          .doc(user.id)
          .update({ConstantStrings.dbString.groupsIdList: groupsIdList});
    } else {
      throw NotJoinedOrRequestedYetException();
    }
  }

  Future<void> addNewRequestToRequestsIdList(String groupId) async {
    Member? user = await getCurrentUser();
    var requestGroupsIdList = user!.requestGroupsIdList;
    if (!requestGroupsIdList.contains(groupId)) {
      requestGroupsIdList.add(groupId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.usersCollection)
          .doc(user.id)
          .update({ConstantStrings.dbString.requestGroupsIdList: requestGroupsIdList});
    } else {
      throw JoinedOrRequestedException();
    }
  }

  Future<void> removeRequestFromRequestsIdList(String userId, String groupId) async {
    Member? user = await getUserById(userId);
    var requestGroupsIdList = user.requestGroupsIdList;
    if (requestGroupsIdList.contains(groupId)) {
      requestGroupsIdList.remove(groupId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.usersCollection)
          .doc(user.id)
          .update({ConstantStrings.dbString.requestGroupsIdList: requestGroupsIdList});
    } else {
      throw NotJoinedOrRequestedYetException();
    }
  }

  Future<void> updateUserImageURL(String userId, String imageURL) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.usersCollection)
        .doc(userId)
        .update({ConstantStrings.dbString.imageURL: imageURL});
  }

  Future<void> updateFirstName(String userId, String firstName) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.usersCollection)
        .doc(userId)
        .update({ConstantStrings.dbString.firstName: firstName});
  }

  Future<void> updateLastName(String userId, String lastName) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.usersCollection)
        .doc(userId)
        .update({ConstantStrings.dbString.lastName: lastName});
  }

  Future<void> changePassword(String password) async {
    User user = firebaseAuth.currentUser!;
    await user.updatePassword(password);
    String hashPassword = encrypt(password);
    await firebaseFirestore
        .collection(ConstantStrings.dbString.usersCollection)
        .doc(user.uid)
        .update({ConstantStrings.dbString.hashPassword: hashPassword});
  }

}
