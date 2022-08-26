import 'package:json_annotation/json_annotation.dart';
import 'package:pearmeta_fapp/models/art.model.dart';

part 'artList2.model.g.dart';

@JsonSerializable()
class ArtList2 {
  ArtList2(this.data);

  List<Art> data;

  factory ArtList2.fromJson(Map<String, dynamic> json) =>
      _$ArtList2FromJson(json);

  Map<String, dynamic> toJson() => _$ArtList2ToJson(this);
}
