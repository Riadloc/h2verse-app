// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artList2.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtList2 _$ArtList2FromJson(Map<String, dynamic> json) => ArtList2(
      (json['data'] as List<dynamic>)
          .map((e) => Art.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtList2ToJson(ArtList2 instance) => <String, dynamic>{
      'data': instance.data,
    };
