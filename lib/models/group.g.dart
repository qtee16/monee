// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as String,
      name: json['name'] as String,
      imageURL: json['imageURL'] as String,
      ownersIdList: json['ownersIdList'] as List<dynamic>? ?? [],
      membersIdList: json['membersIdList'] as List<dynamic>? ?? [],
      requestsIdList: json['requestsIdList'] as List<dynamic>? ?? [],
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageURL': instance.imageURL,
      'ownersIdList': instance.ownersIdList,
      'membersIdList': instance.membersIdList,
      'requestsIdList': instance.requestsIdList,
    };
