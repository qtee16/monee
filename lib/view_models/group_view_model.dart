import 'dart:async';

import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/member.dart';
import '../repositories/global_repo.dart';

class GroupViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.instance;

  Stream<List<Group>> groupsListStream() {
    final controller = StreamController<List<Group>>();
    Stream<List<Group>> stream = controller.stream;
    globalRepo.getStreamCurrentUser().listen((event) async {
      if (event.data() != null) {
        var member = Member.fromJson(event.data()!);
        List<Group> groupsList = await getGroupsListByIds(member.groupsIdList);
        controller.add(groupsList);
      }
    });
    return stream;
  }

  Stream<List<Group>> requestGroupsListStream() {
    final controller = StreamController<List<Group>>();
    Stream<List<Group>> stream = controller.stream;
    globalRepo.getStreamCurrentUser().listen((event) async {
      if (event.data() != null) {
        var member = Member.fromJson(event.data()!);
        List<Group> requestGroupsList = await getGroupsListByIds(member.requestGroupsIdList);
        controller.add(requestGroupsList);
      }
    });
    return stream;
  }

  Future<Group> getGroupById(String id) async {
    return await globalRepo.getGroupById(id);
  }

  Stream<Group> getStreamGroupById(String groupId) {
    final controller = StreamController<Group>();
    Stream<Group> stream = controller.stream;
    globalRepo.getStreamGroupById(groupId).listen((event) async {
      if (event.data() != null) {
        var group = Group.fromJson(event.data()!);
        controller.add(group);
      }
    });
    return stream;
  }

  Future<List<Group>> getGroupsListByIds(List<dynamic> groupsIdList) async {
    List<Group> groupsList = [];
    for (var element in groupsIdList) {
      var group = await getGroupById(element);
      groupsList.add(group);
    }
    return groupsList;
  }

  Future<void> requestToJoinGroup(String groupId) async {
    await globalRepo.requestToJoinGroup(groupId);
  }

  Future<void> acceptRequestToJoinGroup(String userId, String groupId) async {
    await globalRepo.acceptRequestToJoinGroup(userId, groupId);
  }

  Future<void> deleteRequestToJoinGroup(String groupId, {String? userId}) async {
    userId ??= globalRepo.getCurrentUserId();
    await globalRepo.removeRequestToJoinGroup(userId!, groupId);
  }

  Future<void> removeMemberFromGroup(String groupId, {String? userId}) async {
    userId ??= globalRepo.getCurrentUserId();
    await globalRepo.removeMemberFromGroup(userId!, groupId);
  }

  Future<void> acceptAllRequest(List<dynamic> usersIdList, String groupId) async {
    await globalRepo.acceptAllRequest(usersIdList, groupId);
  }

  Future<void> removeAllRequest(List<dynamic> usersIdList, String groupId) async {
    await globalRepo.removeAllRequest(usersIdList, groupId);
  }

  Future<void> deleteGroup(String groupId) async {
    await globalRepo.deleteGroup(groupId);
  }

  Future<void> addNewOwnerForGroup(String groupId, String userId) async {
    await globalRepo.addNewOwnerForGroup(groupId, userId);
  }

  Future<void> removeAnOwnerFromGroup(String groupId, String userId) async {
    await globalRepo.removeAnOwnerFromGroup(groupId, userId);
  }
}