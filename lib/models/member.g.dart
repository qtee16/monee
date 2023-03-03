// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      imageURL: json['imageURL'] as String?,
      hashPassword: json['hashPassword'] as String,
      groupsIdList: json['groupsIdList'] as List<dynamic>? ?? [],
      requestGroupsIdList: json['requestGroupsIdList'] as List<dynamic>? ?? [],
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'imageURL': instance.imageURL,
      'hashPassword': instance.hashPassword,
      'groupsIdList': instance.groupsIdList,
      'requestGroupsIdList': instance.requestGroupsIdList,
    };
