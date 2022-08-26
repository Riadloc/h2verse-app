// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artList.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtList _$ArtListFromJson(Map<String, dynamic> json) => ArtList(
      (json['list'] as List<dynamic>)
          .map((e) => Art.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['count'] as int,
    );

Map<String, dynamic> _$ArtListToJson(ArtList instance) => <String, dynamic>{
      'list': instance.list,
      'count': instance.count,
    };
