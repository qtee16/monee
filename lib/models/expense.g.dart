// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      groupId: json['groupId'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      date: _fromJson(json['date'] as int),
      type: typeFromJson(json['type'] as int),
      membersIdList: json['membersIdList'] as List<dynamic>,
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'groupId': instance.groupId,
      'name': instance.name,
      'price': instance.price,
      'date': _toJson(instance.date),
      'type': typeToJsonCode(instance.type),
      'membersIdList': instance.membersIdList,
    };
