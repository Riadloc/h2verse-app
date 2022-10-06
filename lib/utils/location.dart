// import 'dart:async';
// import 'dart:io';

// import 'package:amap_flutter_location/amap_flutter_location.dart';
// import 'package:amap_flutter_location/amap_location_option.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Location {
//   static final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
//   static StreamSubscription<Map<String, Object>>? locationListener;

//   static void _setLocationOption() {
//     AMapLocationOption locationOption = AMapLocationOption();

//     ///是否单次定位
//     locationOption.onceLocation = true;

//     ///是否需要返回逆地理信息
//     locationOption.needAddress = true;

//     ///逆地理信息的语言类型
//     locationOption.geoLanguage = GeoLanguage.ZH;

//     locationOption.desiredLocationAccuracyAuthorizationMode =
//         AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

//     locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

//     ///设置Android端的定位模式<br>
//     ///可选值：<br>
//     ///<li>[AMapLocationMode.Battery_Saving]</li>
//     ///<li>[AMapLocationMode.Device_Sensors]</li>
//     ///<li>[AMapLocationMode.Hight_Accuracy]</li>
//     locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

//     ///设置iOS端的定位最小更新距离<br>
//     locationOption.distanceFilter = 100;

//     ///设置iOS端期望的定位精度
//     /// 可选值：<br>
//     /// <li>[DesiredAccuracy.Best] 最高精度</li>
//     /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
//     /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
//     /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
//     /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
//     locationOption.desiredAccuracy = DesiredAccuracy.NearestTenMeters;

//     ///设置iOS端是否允许系统暂停定位
//     locationOption.pausesLocationUpdatesAutomatically = false;

//     ///将定位参数设置给定位插件
//     _locationPlugin.setLocationOption(locationOption);
//   }

//   /// 申请定位权限
//   static Future<bool> requestLocationPermission() async {
//     //获取当前的权限
//     var status = await Permission.location.status;
//     if (status == PermissionStatus.granted) {
//       //已经授权
//       return true;
//     } else {
//       //未授权则发起一次申请
//       status = await Permission.location.request();
//       if (status == PermissionStatus.granted) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//   }

//   static Future<void> requestAccuracyAuthorization() async {
//     AMapAccuracyAuthorization currentAccuracyAuthorization =
//         await _locationPlugin.getSystemAccuracyAuthorization();
//     if (currentAccuracyAuthorization ==
//         AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
//       print("精确定位类型");
//     } else if (currentAccuracyAuthorization ==
//         AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
//       print("模糊定位类型");
//     } else {
//       print("未知定位类型");
//     }
//   }

//   static Future<void> getLocation({
//     required void Function(Map<String, Object> locationData) onLoad,
//     void Function()? onUnperimitted,
//   }) async {
//     bool hasPerimission = await requestLocationPermission();
//     if (!hasPerimission) {
//       onUnperimitted?.call();
//       return;
//     }
//     _setLocationOption();

//     ///iOS 获取native精度类型
//     if (Platform.isIOS) {
//       requestAccuracyAuthorization();
//     }
//     void dispose() {
//       // _locationListener?.cancel();
//     }
//     locationListener ??= _locationPlugin
//         .onLocationChanged()
//         .listen((Map<String, Object> result) {
//       onLoad(result);
//       //
//     });
//     _locationPlugin.startLocation();
//   }

//   static void dispose() {
//     locationListener?.cancel();
//     _locationPlugin.destroy();
//   }
// }
