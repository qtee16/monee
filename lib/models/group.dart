import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
part 'group.g.dart';

@JsonSerializable()
class Group extends Equatable {
  final String id;
  final String name;
  final String imageURL;
  @JsonKey(defaultValue: [])
  final List<dynamic> ownersIdList;
  @JsonKey(defaultValue: [])
  final List<dynamic> membersIdList;
  @JsonKey(defaultValue: [])
  final List<dynamic> requestsIdList;

  const Group({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.ownersIdList,
    required this.membersIdList,
    required this.requestsIdList,
  });

  factory Group.fromJson(Map<String,dynamic> data) => _$GroupFromJson(data);

  Map<String,dynamic> toJson() => _$GroupToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
