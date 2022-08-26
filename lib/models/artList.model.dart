import 'package:json_annotation/json_annotation.dart';
import 'package:pearmeta_fapp/models/art.model.dart';

part 'artList.model.g.dart';

@JsonSerializable()
class ArtList {
  ArtList(this.list, this.count);

  List<Art> list;
  int count;

  factory ArtList.fromJson(Map<String, dynamic> json) =>
      _$ArtListFromJson(json);

  Map<String, dynamic> toJson() => _$ArtListToJson(this);
}
