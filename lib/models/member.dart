import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member extends Equatable{
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? imageURL;
  final String hashPassword;
  @JsonKey(defaultValue: [])
  final List<dynamic> groupsIdList;
  @JsonKey(defaultValue: [])
  final List<dynamic> requestGroupsIdList;

  const Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.imageURL,
    required this.hashPassword,
    required this.groupsIdList,
    required this.requestGroupsIdList,
  });

  factory Member.fromJson(Map<String,dynamic> data) => _$MemberFromJson(data);

  Map<String,dynamic> toJson() => _$MemberToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
