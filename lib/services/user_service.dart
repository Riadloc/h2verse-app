import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h2verse_app/models/address_model.dart';
import 'package:h2verse_app/models/invitation_model.dart';
import 'package:h2verse_app/models/real_user_info_model.dart';
import 'package:h2verse_app/models/user_model.dart';
import 'package:h2verse_app/utils/alert.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/utils/http.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:get/get.dart' as getx;
import 'package:h2verse_app/views/login.dart';

typedef NormalResp = Map<String, dynamic>;

class UserService {
  static Future<int?> sendSms(String phone, String code) async {
    EasyLoading.show(status: 'loading');
    Response response;
    response = await HttpUtils()
        .dio
        .post('/user/send_sms', data: {'phone': phone, 'code': code});
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      return response.data['data'] as int;
    }
    Alert.reqFail(response.data['msg']);
    return null;
  }

  static Future login({
    required String phone,
    String? code,
    String? password,
  }) async {
    var data = {'phone': phone, 'code': code, 'password': password};
    var reportData = await getReportParams();
    data.addAll(reportData);
    Response response;
    response = await HttpUtils().dio.post('/user/login', data: data);
    if (response.data['code'] == 0) {
      Toast.show('登录成功！');
      NormalResp data = response.data['data'];
      return User.fromJson(data);
    }
    Alert.reqFail(response.data['msg']);
  }

  static Future singup({
    required String phone,
    required String code,
    required String password,
  }) async {
    var data = {'phone': phone, 'code': code, 'password': password};
    Response response;
    response = await HttpUtils().dio.post('/user/singup', data: data);
    if (response.data['code'] == 0) {
      Toast.show('注册成功！');
      NormalResp data = response.data['data'];
      return User.fromJson(data);
    }
    Alert.reqFail(response.data['msg']);
  }

  static Future logout() async {
    var reportData = await getReportParams();
    Response response;
    response = await HttpUtils().dio.post('/user/logout', data: reportData);
    if (response.data['code'] == 0) {
      Toast.show('退出登录成功');
      getx.Get.offAllNamed(Login.routeName);
      return;
    }
    Alert.reqFail(response.data['msg']);
  }

  static Future getUserInfo() async {
    Response response;
    response = await HttpUtils().dio.get('/user');
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return User.fromJson(data);
    }
    // Alert.reqFail(response.data['msg']);
    return User.empty();
  }

  static Future<RealUserInfo> getUserCertifiedInfo() async {
    EasyLoading.show(status: 'loading');
    Response response;
    response = await HttpUtils().dio.get('/user/certifiedInfo');
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return RealUserInfo.fromMap(data);
    }
    Alert.reqFail(response.data['msg']);
    return RealUserInfo.empty();
  }

  static Future updateUserInfo({required String name, String? email}) async {
    var data = {'name': name};
    if (email != null) {
      data['email'] = email;
    }
    Response response;
    response = await HttpUtils().dio.put('/user/info', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future changePassword(
      {required String phone,
      required String password,
      required String code}) async {
    var data = {'phone': phone, 'password': password, 'code': code};
    Response response;
    response = await HttpUtils().dio.put('/user/password', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future applyMetaAccount() async {
    Response response;
    response = await HttpUtils().dio.post('/user/apply/metaAccount');
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future preCertify(
      {required String realName,
      required String idNo,
      required String phone}) async {
    EasyLoading.show(status: 'loading');
    var data = {'realName': realName, 'idNo': idNo, 'phone': phone};
    Response response;
    response = await HttpUtils().dio.post('/user/preCertifyV2', data: data);
    EasyLoading.dismiss();
    // if (response.data['code'] == 0) {
    //   NormalResp data = response.data['data'];
    // }
    return response.data['data'];
  }

  static Future certify(
      {required String verifyId,
      required String code,
      required String realName,
      required String idNo}) async {
    var data = {
      'verifyId': verifyId,
      'code': code,
      'realName': realName,
      'idNo': idNo
    };
    EasyLoading.show(status: 'loading');
    var reportData = await getReportParams();
    data.addAll(reportData);
    Response response;
    response = await HttpUtils().dio.post('/user/certifyV2', data: data);
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      Toast.show('实名认证成功！');
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future<Address?> getAddress() async {
    EasyLoading.show(status: 'loading');
    Response response;
    response = await HttpUtils().dio.get('/user/address');
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      var data = response.data['data'];
      if (data != null) {
        return Address.fromJson(data);
      }
      return null;
    }
    Alert.reqFail(response.data['msg']);
    return null;
  }

  static Future saveAddress(
      {required String phone,
      required String name,
      required String area,
      required String address}) async {
    var data = {'phone': phone, 'name': name, 'area': area, 'address': address};
    EasyLoading.show(status: 'loading');
    Response response;
    response = await HttpUtils().dio.post('/user/address', data: data);
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future savePayKey({
    required String payKey,
    required String password,
  }) async {
    var data = {'payKey': payKey, 'password': password};
    Response response;
    response = await HttpUtils().dio.post('/user/paysafety/set', data: data);
    if (response.data['code'] == 0) {
      return true;
    }
    Alert.reqFail(response.data['msg']);
    return false;
  }

  static Future getInvitations(
      {required int pageNo, required int pageSize}) async {
    var queryParameters = {'pageNo': pageNo, 'pageSize': pageSize};
    EasyLoading.show(status: 'loading');
    Response response = await HttpUtils()
        .dio
        .get('/user/invitation', queryParameters: queryParameters);
    EasyLoading.dismiss();
    if (response.data['code'] == 0) {
      NormalResp data = response.data['data'];
      return [
        data['count'],
        (data['list'] as List<dynamic>)
            .map((e) => Invitation.fromJson(e as NormalResp))
            .toList()
      ];
    }
    Alert.reqFail(response.data['msg']);
    return [0, []];
  }
}
