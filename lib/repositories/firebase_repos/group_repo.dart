import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/exception.dart';
import 'package:spending_app/models/group.dart';

class GroupRepo {
  final FirebaseFirestore firebaseFirestore;

  GroupRepo({required this.firebaseFirestore});

  Future<void> createNewGroup(
    String id,
    String name,
    String imageURL,
    List<dynamic> ownersIdList,
    List<dynamic> membersIdList,
  ) async {
    Group group = Group(
      id: id,
      name: name,
      imageURL: imageURL,
      ownersIdList: ownersIdList,
      membersIdList: membersIdList,
      requestsIdList: [],
    );
    await firebaseFirestore
        .collection(ConstantStrings.dbString.groupsCollection)
        .doc(id)
        .set(group.toJson());
  }

  Future<Group> getGroupById(String id) async {
    var query = await firebaseFirestore
        .collection(ConstantStrings.dbString.groupsCollection)
        .doc(id)
        .get();
    if (query.exists) {
      var group = Group.fromJson(query.data()!);
      return group;
    } else {
      throw NotFoundGroupException();
    }
  }

  Future<List<Group>> getAllGroupsByIdList(List<dynamic> groupsIdList) async {
    List<Group> groups = [];
    for (var id in groupsIdList) {
      Group group = await getGroupById(id);
      groups.add(group);
    }
    return groups;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamGroupById(
      String groupId) {
    return firebaseFirestore
        .collection(ConstantStrings.dbString.groupsCollection)
        .doc(groupId)
        .snapshots();
  }

  Future<void> joinGroup(String userId, String groupId) async {
    var group = await getGroupById(groupId);
    var membersIdList = group.membersIdList;
    if (!membersIdList.contains(userId)) {
      membersIdList.add(userId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.groupsCollection)
          .doc(groupId)
          .update({ConstantStrings.dbString.membersIdList: membersIdList});
    } else {
      throw JoinedOrRequestedException();
    }
  }

  Future<void> removeMemberFromGroup(String userId, String groupId) async {
    var group = await getGroupById(groupId);
    var membersIdList = group.membersIdList;
    var ownersIdList = group.ownersIdList;
    if (ownersIdList.contains(userId) && membersIdList.contains(userId)) {
      ownersIdList.remove(userId);
      membersIdList.remove(userId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.groupsCollection)
          .doc(groupId)
          .update({
        ConstantStrings.dbString.membersIdList: membersIdList,
        ConstantStrings.dbString.ownersIdList: ownersIdList,
      });
    } else if (membersIdList.contains(userId)) {
      membersIdList.remove(userId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.groupsCollection)
          .doc(groupId)
          .update({ConstantStrings.dbString.membersIdList: membersIdList});
    } else {
      throw NotJoinedOrRequestedYetException();
    }
  }

  Future<void> requestToJoinGroup(String userId, String groupId) async {
    var group = await getGroupById(groupId);
    var requestsIdList = group.requestsIdList;
    var membersIdList = group.membersIdList;
    if (!requestsIdList.contains(userId) && !membersIdList.contains(userId)) {
      requestsIdList.add(userId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.groupsCollection)
          .doc(groupId)
          .update({ConstantStrings.dbString.requestsIdList: requestsIdList});
    } else {
      throw JoinedOrRequestedException();
    }
  }

  Future<void> removeRequestToJoinGroup(String userId, String groupId) async {
    var group = await getGroupById(groupId);
    var requestsIdList = group.requestsIdList;
    if (requestsIdList.contains(userId)) {
      requestsIdList.remove(userId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.groupsCollection)
          .doc(groupId)
          .update({ConstantStrings.dbString.requestsIdList: requestsIdList});
    } else {
      throw NotJoinedOrRequestedYetException();
    }
  }

  Future<void> updateGroupImageURL(String groupId, String imageURL) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.groupsCollection)
        .doc(groupId)
        .update({ConstantStrings.dbString.imageURL: imageURL});
  }

  Future<void> updateGroupName(String groupId, String name) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.groupsCollection)
        .doc(groupId)
        .update({ConstantStrings.dbString.name: name});
  }

  Future<void> deleteGroup(String groupId) async {
    await firebaseFirestore
        .collection(ConstantStrings.dbString.groupsCollection)
        .doc(groupId)
        .delete();
  }

  Future<void> addNewOwnerForGroup(String groupId, String userId) async {
    Group group = await getGroupById(groupId);
    var ownersIdList = group.ownersIdList;
    if (!ownersIdList.contains(userId)) {
      ownersIdList.add(userId);
      await firebaseFirestore
          .collection(ConstantStrings.dbString.groupsCollection)
          .doc(groupId)
          .update({ConstantStrings.dbString.ownersIdList: ownersIdList});
    }
  }

  Future<void> removeAnOwnerFromGroup(String groupId, String userId) async {
    Group group = await getGroupById(groupId);
    var ownersIdList = group.ownersIdList;
    if (ownersIdList.length == 1) {
      throw YouAreOnlyOwnerOfGroupException();
    } else {
      if (ownersIdList.contains(userId)) {
        ownersIdList.remove(userId);
        await firebaseFirestore
            .collection(ConstantStrings.dbString.groupsCollection)
            .doc(groupId)
            .update({ConstantStrings.dbString.ownersIdList: ownersIdList});
      }
    }
  }

  getData(groupId) async {
    var data = await firebaseFirestore
        .collection(ConstantStrings.dbString.expenseGroupsCollection)
        .doc(groupId)
        .get();
    print(data.data());
  }
}
