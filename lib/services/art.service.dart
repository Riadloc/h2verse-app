import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:pearmeta_fapp/models/art.model.dart';
import 'package:pearmeta_fapp/models/artList.model.dart';
import 'package:pearmeta_fapp/models/artSnsList.model.dart';
import 'package:pearmeta_fapp/models/bank_card.model.dart';
import 'package:pearmeta_fapp/models/marketList.model.dart';
import 'package:pearmeta_fapp/models/orderList.model.dart';
import 'package:pearmeta_fapp/models/user.model.dart';
import 'package:pearmeta_fapp/utils/http.dart';
import 'package:pearmeta_fapp/utils/alert.dart';
import 'package:pearmeta_fapp/utils/toast.dart';

import 'package:pearmeta_fapp/views/home_wrapper.dart';

typedef NormalResp = Map<String, dynamic>;

class ArtService {
  late final Dio dio;
  final Map<String, bool> noLoading = {'showIndicator': false};

  ArtService() {
    dio = HttpUtils().dio;
  }

  Future<ArtList> getArts(int pageNo) async {
    try {
      Response response;
      response = await dio
          .get('/goods', queryParameters: {'pageNo': pageNo, 'pageSize': 12});
      if (response.data['code'] == 0) {
        NormalResp data = response.data['data'];
        return ArtList.fromJson(data);
      }
      return ArtList([], 0);
    } catch (e) {
      Alert.reqFail('请联系管理员');
      rethrow;
    }
  }

  Future<MarketListModel> getMarketArts(
      {required int pageNo, required int type}) async {
    final formdata = {'pageNo': pageNo, 'pageSize': 12, 'type': type};
    try {
      Response response;
      response = await dio.get('/goods/market', queryParameters: formdata);
      if (response.data['code'] == 0) {
        NormalResp data = response.data;
        return MarketListModel.fromJson(data);
      }
      return MarketListModel(data: []);
    } catch (e) {
      Alert.reqFail('请联系管理员');
      rethrow;
    }
  }

  Future<Art> getArtDetail(String goodNo) async {
    Map<String, dynamic> queryParameters = {'goodNo': goodNo};
    queryParameters.addAll(noLoading);
    try {
      Response response;
      response =
          await dio.get('/goods/detail', queryParameters: queryParameters);
      if (response.data['code'] == 0) {
        NormalResp data = response.data['data'];
        return Art.fromJson(data);
      }
      return Art.empty();
    } catch (e) {
      rethrow;
    }
  }

  Future<Art> getFluxArtDetail(String goodNo) async {
    Map<String, dynamic> queryParameters = {'goodNo': goodNo};
    queryParameters.addAll(noLoading);
    try {
      Response response;
      response =
          await dio.get('/goods/flux/detail', queryParameters: queryParameters);
      if (response.data['code'] == 0) {
        NormalResp data = response.data['data'];
        return Art.fromJson(data);
      }
      return Art.empty();
    } catch (e) {
      rethrow;
    }
  }

  Future sendSms(String phone, String code) async {
    try {
      Response response;
      response = await dio
          .post('/user/send_sms', data: {'phone': phone, 'code': code});
      if (response.data['code'] == 0) {
        //
      }
    } catch (e) {
      rethrow;
    }
  }

  Future login({
    required String phone,
    String? code,
    String? password,
  }) async {
    try {
      Response response;
      response = await dio.post('/user/login',
          data: {'phone': phone, 'code': code, 'password': password});
      if (response.data['code'] == 0) {
        Toast.show('登录成功！');
        getx.Get.offAllNamed(HomeWrapper.routeName);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getUserInfo() async {
    try {
      Response response;
      response = await dio.get('/user');
      if (response.data['code'] == 0) {
        NormalResp data = response.data['data'];
        return User.fromJson(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getMyArts({required int pageNo, required int type}) async {
    var query = {'pageNo': pageNo, 'pageSize': 12, 'catalogue': type};
    try {
      Response response;
      response = await dio.get('/goods/collect', queryParameters: query);
      if (response.data['code'] == 0) {
        NormalResp data = response.data['data'];
        return ArtList.fromJson(data);
      }
      return ArtList([], 0);
    } catch (e) {
      rethrow;
    }
  }

  Future getMyArtsSns({required int pageNo, required String goodId}) async {
    var query = {'pageNo': pageNo, 'pageSize': 12, 'goodId': goodId};
    try {
      Response response;
      response = await dio.get('/goods/collect/sns', queryParameters: query);
      if (response.data['code'] == 0) {
        NormalResp data = response.data['data'];
        return ArtSnsList.fromJson(data);
      }
      return ArtSnsList(list: [], count: 0);
    } catch (e) {
      rethrow;
    }
  }

  Future getOrders({required int pageNo, required int type}) async {
    var query = {'pageNo': pageNo, 'pageSize': 12, 'status': type};
    try {
      Response response;
      response = await dio.get('/order/list', queryParameters: query);
      if (response.data['code'] == 0) {
        NormalResp data = response.data['data'];
        return OrderList.fromJson(data);
      }
      return OrderList(list: [], count: 0);
    } catch (e) {
      rethrow;
    }
  }

  Future preCertify(
      {required String realName,
      required String idNo,
      required String phone}) async {
    var data = {'realName': realName, 'idNo': idNo, 'phone': phone};
    try {
      Response response;
      response = await dio.post('/user/preCertifyV2', data: data);
      // if (response.data['code'] == 0) {
      //   NormalResp data = response.data['data'];
      // }
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future certify({required String verifyId, required String code}) async {
    var data = {'verifyId': verifyId, 'code': code};
    try {
      Response response;
      response = await dio.post('/user/certifyV2', data: data);
      if (response.data['code'] == 0) {
        Toast.show('实名认证成功！');
        return true;
      }
      Alert.reqFail(response.data['msg']);
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BankCard>> getBankList() async {
    try {
      Response response;
      response = await dio.get('/wallet/bankList');
      if (response.data['code'] == 0) {
        List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => BankCard.fromJson(e)).toList();
      }
      Alert.reqFail(response.data['msg']);
      return [];
    } catch (e) {
      rethrow;
    }
  }
}

final ArtService artService = ArtService();
