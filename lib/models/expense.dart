import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spending_app/utils/enums/type_bill_enum.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense extends Equatable {
  final String id;
  final String ownerId;
  final String groupId;
  final String name;
  final int price;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime date;
  @JsonKey(fromJson: typeFromJson, toJson: typeToJsonCode)
  final TypeBill type;
  final List<dynamic> membersIdList;

  const Expense({
    required this.id,
    required this.ownerId,
    required this.groupId,
    required this.name,
    required this.price,
    required this.date,
    required this.type,
    required this.membersIdList,
  });

  factory Expense.fromJson(Map<String,dynamic> data) => _$ExpenseFromJson(data);

  Map<String,dynamic> toJson() => _$ExpenseToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

int typeToJsonCode(TypeBill type) => type.toDBCode();
TypeBill typeFromJson(int typeBillCode) => TypeBillX.fromDBCode(typeBillCode);

DateTime _fromJson(int int) => DateTime.fromMillisecondsSinceEpoch(int);
int _toJson(DateTime time) => time.millisecondsSinceEpoch;
