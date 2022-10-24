import 'package:dio/dio.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/models/art_sns_model.dart';
import 'package:h2verse_app/models/box_result_model.dart';
import 'package:h2verse_app/models/compose_material_model.dart';
import 'package:h2verse_app/models/compose_model.dart';
import 'package:h2verse_app/models/market_item_model.dart';
import 'package:h2verse_app/utils/http.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/toast.dart';

typedef NormalResp = Map<String, dynamic>;

class ArtService {
  static final Map<String, bool> noLoading = {'showIndicator': false};

  static Future<List<Art>> getArts(int pageNo) async {
    Response response;
    response = await HttpUtils()
        .dio
        .get('/goods', queryParameters: {'pageNo': pageNo, 'pageSize': 12});
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return (data['list'] as List<dynamic>)
          .map((e) => Art.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<List<MarketItem>> getMarketArts(
      {required int pageNo,
      required int type,
      required String query,
      int? sortKey}) async {
    var queryParameters = {
      'pageNo': pageNo,
      'pageSize': 12,
      'type': type,
      'keyword': query
    };
    if (sortKey != null) {
      queryParameters['sortKey'] = sortKey;
    }
    Response response;
    response = await Future.delayed(
        const Duration(milliseconds: 500),
        () => HttpUtils()
            .dio
            .get('/goods/market', queryParameters: queryParameters));
    if (response.data['code'] == 0) {
      NormalResp data = response.data;
      return (data['data'] as List<dynamic>)
          .map((e) => MarketItem.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<Art> getArtDetail(String goodId) async {
    Map<String, dynamic> queryParameters = {'goodId': goodId};
    queryParameters.addAll(noLoading);
    Response response;
    response = await Future.delayed(
        const Duration(milliseconds: 500),
        () => HttpUtils()
            .dio
            .get('/goods/detail', queryParameters: queryParameters));
    // response = await HttpUtils()
    //     .dio
    //     .get('/goods/detail', queryParameters: queryParameters);
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return Art.fromJson(data);
    }
    Alert.reqFail(response.data['msg']);
    return Art.empty();
  }

  static Future<Art> getFluxArtDetail(String goodId) async {
    Map<String, dynamic> queryParameters = {'goodId': goodId};
    queryParameters.addAll(noLoading);
    Response response;
    response = await Future.delayed(
        const Duration(milliseconds: 500),
        () => HttpUtils()
            .dio
            .get('/goods/flux/detail', queryParameters: queryParameters));
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return Art.fromJson(data);
    }
    Alert.reqFail(response.data['msg']);
    return Art.empty();
  }

  static Future<List<Art>> getMyArts(
      {required int pageNo, required int type}) async {
    var query = {'pageNo': pageNo, 'pageSize': 12, 'catalogue': type};
    Response response;
    response = await Future.delayed(const Duration(milliseconds: 500),
        () => HttpUtils().dio.get('/goods/collect', queryParameters: query));
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return (data['list'] as List<dynamic>)
          .map((e) => Art.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<List<ArtSns>> getMyArtsSns(
      {required int pageNo, required String goodId}) async {
    var query = {'pageNo': pageNo, 'pageSize': 12, 'goodId': goodId};
    Response response;
    response =
        await HttpUtils().dio.get('/goods/collect/sns', queryParameters: query);
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return (data['list'] as List<dynamic>)
          .map((e) => ArtSns.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future putOnMarket(
      {required String goodId, required String price}) async {
    var data = {'goodId': goodId, 'price': price};
    Response response;
    response = await HttpUtils().dio.post('/goods/market/puton', data: data);
    if (response.data['code'] == 0) {
      Toast.show('寄售成功');
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future putOffMarket({required String goodId}) async {
    var data = {'goodId': goodId};
    Response response;
    response = await HttpUtils().dio.post('/goods/market/putoff', data: data);
    if (response.data['code'] == 0) {
      Toast.show('已取消寄售');
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future<List<ComposeItem>> getComposeList(
      {required int pageNo, required int pageSize}) async {
    var query = {'pageNo': pageNo, 'pageSize': pageSize};
    Response response = await HttpUtils()
        .dio
        .get('/goods/compose/list', queryParameters: query);
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return (data['list'] as List<dynamic>)
          .map((e) => ComposeItem.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future<ComposeItem?> getComposeDetail({required String id}) async {
    var query = {'id': id};
    Response response = await HttpUtils()
        .dio
        .get('/goods/compose/detail', queryParameters: query);
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return ComposeItem.fromJson(data);
    }
    Alert.reqFail(response.data['msg']);
    return null;
  }

  static Future getComposeMaterials({required String goodId}) async {
    var query = {'goodId': goodId};
    Response response = await HttpUtils()
        .dio
        .get('/goods/compose/materials', queryParameters: query);
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return (data as List<dynamic>)
          .map((e) => ComposeMaterial.fromJson(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future onCompose(
      {required String id, required List<String> materials}) async {
    var data = {'id': id, 'materials': materials};
    Response response =
        await HttpUtils().dio.post('/goods/compose', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future<BoxResult?> postOpenboxOne({required String id}) async {
    var data = {'id': id};
    Response response =
        await HttpUtils().dio.post('/goods/openBox', data: data);
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return BoxResult.fromMap(data);
    }
    Alert.reqFail(response.data['msg']);
    return null;
  }

  static Future<List<BoxResult>> postOpenboxAll({required String id}) async {
    var data = {'id': id};
    Response response =
        await HttpUtils().dio.post('/goods/openBoxAll', data: data);
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      return (data as List<dynamic>)
          .map((e) => BoxResult.fromMap(e as NormalResp))
          .toList();
    }
    Alert.reqFail(response.data['msg']);
    return [];
  }

  static Future postSubscribe(String id) async {
    var data = {'id': id};
    Response response =
        await HttpUtils().dio.post('/goods/subscribe', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future postGift(
      {required String goodId,
      required String receiver,
      required String payKey}) async {
    var data = {'goodId': goodId, 'receiver': receiver, 'payKey': payKey};
    Response response = await HttpUtils().dio.post('/goods/giftto', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future<List<Art>> getUserShow(
      {required int pageNo, required int type, required String uid}) async {
    var queryParameters = {
      'pageNo': pageNo,
      'pageSize': 12,
      'type': type,
      'uid': uid
    };
    Response response;
    response = await Future.delayed(
        const Duration(milliseconds: 500),
        () => HttpUtils()
            .dio
            .get('/goods/exhibit', queryParameters: queryParameters));
    if (response.data['code'] == 0) {
      NormalResp data = response.data;
      return (data['data'] as List<dynamic>)
          .map((e) => Art.fromJson(e as NormalResp))
          .toList();
    }
    print(response.data);
    Alert.reqFail(response.data['msg']);
    return [];
  }
}
