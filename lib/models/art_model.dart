// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Art {
  final String id;
  final String cover;
  final String name;
  final num price;
  final String? ownner;
  final int? copies;
  final int? realCopies;
  final String? serial;
  final int? status;
  final int? limit;
  final String? ownerUuid;
  final String? description;
  final List<dynamic>? pictures;
  final bool? isBox;
  final int? type;
  final int? level;
  final List<dynamic>? boxs;
  final String? tokenId;
  final String? powerId;
  final String? goodNo;
  final int? count;
  final int? operatorStatus;
  final List<ArtNode>? nodes;
  final int? nodeIndex;
  final int? showNodes;
  final int? reservation;
  final int? shelfTime;
  Art({
    required this.id,
    required this.cover,
    required this.name,
    required this.price,
    this.ownner,
    this.copies,
    this.realCopies,
    this.serial,
    this.status,
    this.limit,
    this.ownerUuid,
    this.description,
    this.pictures,
    this.isBox,
    this.type,
    this.level,
    this.boxs,
    this.tokenId,
    this.powerId,
    this.goodNo,
    this.count,
    this.operatorStatus,
    this.nodes,
    this.nodeIndex,
    this.showNodes = 0,
    this.reservation = 0,
    this.shelfTime,
  });

  Art copyWith({
    String? id,
    String? cover,
    String? name,
    num? price,
    String? ownner,
    int? copies,
    int? realCopies,
    String? serial,
    int? status,
    int? limit,
    String? ownerUuid,
    String? description,
    List<dynamic>? pictures,
    bool? isBox,
    int? type,
    int? level,
    List<dynamic>? boxs,
    String? tokenId,
    String? goodNo,
    int? count,
    int? operatorStatus,
    List<ArtNode>? nodes,
    int? nodeIndex,
    int? showNodes,
    int? reservation,
    int? shelfTime,
  }) {
    return Art(
        id: id ?? this.id,
        cover: cover ?? this.cover,
        name: name ?? this.name,
        price: price ?? this.price,
        ownner: ownner ?? this.ownner,
        copies: copies ?? this.copies,
        realCopies: realCopies ?? this.realCopies,
        serial: serial ?? this.serial,
        status: status ?? this.status,
        limit: limit ?? this.limit,
        ownerUuid: ownerUuid ?? this.ownerUuid,
        description: description ?? this.description,
        pictures: pictures ?? this.pictures,
        isBox: isBox ?? this.isBox,
        type: type ?? this.type,
        level: level ?? this.level,
        boxs: boxs ?? this.boxs,
        tokenId: tokenId ?? this.tokenId,
        powerId: powerId ?? this.powerId,
        goodNo: goodNo ?? this.goodNo,
        count: count ?? this.count,
        operatorStatus: operatorStatus ?? this.operatorStatus,
        nodes: nodes ?? this.nodes,
        nodeIndex: nodeIndex ?? this.nodeIndex,
        showNodes: showNodes ?? this.showNodes,
        reservation: reservation ?? this.reservation,
        shelfTime: shelfTime ?? this.shelfTime);
  }

  factory Art.empty() => Art(id: '', cover: '', name: '', price: 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cover': cover,
      'name': name,
      'price': price,
      'ownner': ownner,
      'copies': copies,
      'realCopies': realCopies,
      'serial': serial,
      'status': status,
      'limit': limit,
      'ownerUuid': ownerUuid,
      'description': description,
      'pictures': pictures,
      'isBox': isBox,
      'type': type,
      'level': level,
      'boxs': boxs,
      'tokenId': tokenId,
      'powerId': powerId,
      'goodNo': goodNo,
      'count': count,
      'operatorStatus': operatorStatus,
      'nodes': nodes?.toList(),
      'nodeIndex': nodeIndex,
      'showNodes': showNodes,
      'reservation': reservation,
      'shelfTime': shelfTime
    };
  }

  factory Art.fromJson(Map<String, dynamic> map) {
    return Art(
      id: map['id'] as String,
      cover: map['cover'] as String,
      name: map['name'] as String,
      price: map['price'] as num,
      ownner: map['ownner'] != null ? map['ownner'] as String : null,
      copies: map['copies'] != null ? map['copies'] as int : null,
      realCopies: map['realCopies'] != null ? map['realCopies'] as int : null,
      serial: map['serial'] != null ? map['serial'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      limit: map['limit'] != null ? map['limit'] as int : null,
      ownerUuid: map['ownerUuid'] != null ? map['ownerUuid'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      pictures: map['pictures'] != null
          ? List<dynamic>.from((map['pictures'] as List<dynamic>))
          : null,
      isBox: map['isBox'] != null ? map['isBox'] as bool : null,
      type: map['type'] != null ? map['type'] as int : null,
      level: map['level'] != null ? map['level'] as int : null,
      boxs: map['boxs'] != null
          ? List<dynamic>.from((map['boxs'] as List<dynamic>))
          : null,
      tokenId: map['tokenId'] != null ? map['tokenId'] as String : null,
      powerId: map['powerId'] != null ? map['powerId'] as String : null,
      goodNo: map['goodNo'] != null ? map['goodNo'] as String : null,
      count: map['count'] != null ? map['count'] as int : null,
      operatorStatus:
          map['operatorStatus'] != null ? map['operatorStatus'] as int : null,
      nodes: map['nodes'] != null
          ? (map['nodes'] as List<dynamic>)
              .map((e) => ArtNode.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      nodeIndex: map['nodeIndex'] != null ? map['nodeIndex'] as int : null,
      showNodes: map['showNodes'] != null ? map['showNodes'] as int : null,
      reservation:
          map['reservation'] != null ? map['reservation'] as int : null,
      shelfTime: map['shelfTime'] != null ? map['shelfTime'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Art(id: $id, cover: $cover, name: $name, price: $price, ownner: $ownner, copies: $copies, realCopies: $realCopies, serial: $serial, status: $status, limit: $limit, ownerUuid: $ownerUuid, description: $description, pictures: $pictures, isBox: $isBox, type: $type, level: $level, boxs: $boxs, tokenId: $tokenId, powerId: $powerId, goodNo: $goodNo, count: $count, operatorStatus: $operatorStatus, nodes: $nodes, nodeIndex: $nodeIndex, showNodes: $showNodes, shelfTime: $shelfTime)';
  }

  @override
  bool operator ==(covariant Art other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.cover == cover &&
        other.name == name &&
        other.price == price &&
        other.ownner == ownner &&
        other.copies == copies &&
        other.realCopies == realCopies &&
        other.serial == serial &&
        other.status == status &&
        other.limit == limit &&
        other.ownerUuid == ownerUuid &&
        other.description == description &&
        listEquals(other.pictures, pictures) &&
        other.isBox == isBox &&
        other.type == type &&
        other.level == level &&
        listEquals(other.boxs, boxs) &&
        other.tokenId == tokenId &&
        other.powerId == powerId &&
        other.goodNo == goodNo &&
        other.count == count &&
        other.operatorStatus == operatorStatus &&
        other.nodes == nodes &&
        other.nodeIndex == nodeIndex &&
        other.showNodes == showNodes &&
        other.shelfTime == shelfTime &&
        other.reservation == reservation;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cover.hashCode ^
        name.hashCode ^
        price.hashCode ^
        ownner.hashCode ^
        copies.hashCode ^
        realCopies.hashCode ^
        serial.hashCode ^
        status.hashCode ^
        limit.hashCode ^
        ownerUuid.hashCode ^
        description.hashCode ^
        pictures.hashCode ^
        isBox.hashCode ^
        type.hashCode ^
        level.hashCode ^
        boxs.hashCode ^
        tokenId.hashCode ^
        powerId.hashCode ^
        goodNo.hashCode ^
        count.hashCode ^
        operatorStatus.hashCode ^
        nodes.hashCode ^
        nodeIndex.hashCode ^
        showNodes.hashCode ^
        reservation.hashCode;
  }
}

class ArtNode {
  final int id;
  final String name;
  final int hidden;
  final int time;
  ArtNode({
    required this.id,
    required this.name,
    required this.hidden,
    required this.time,
  });

  ArtNode copyWith({
    int? id,
    String? name,
    int? hidden,
    int? time,
  }) {
    return ArtNode(
      id: id ?? this.id,
      name: name ?? this.name,
      hidden: hidden ?? this.hidden,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hidden': hidden,
      'time': time,
    };
  }

  factory ArtNode.fromMap(Map<String, dynamic> map) {
    return ArtNode(
      id: map['id'] as int,
      name: map['name'] as String,
      hidden: map['hidden'] as int,
      time: map['time'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtNode.fromJson(String source) =>
      ArtNode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtNode(id: $id, name: $name, hidden: $hidden, time: $time)';
  }

  @override
  bool operator ==(covariant ArtNode other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.hidden == hidden &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ hidden.hashCode ^ time.hashCode;
  }
}
