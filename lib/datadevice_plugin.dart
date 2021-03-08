
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:datadevice_plugin/datadevice_model.dart';
import 'package:flutter/services.dart';

/// ## DevicePlugin
/// Obtener información actual del dispositivo móvil.
///
///```dart
///   DevicePlugin.fromPlatform().then((DeviceModel value) {
///   ...
///   });
///
///   DeviceModel model = await DevicePlugin.fromPlatform();
/// ```
///
class DatadevicePlugin {
  static const MethodChannel _Channel = const MethodChannel('datadevice_plugin');
  static DeviceModel _fromPlatform;

  static Future<DeviceModel> fromPlatform() async {
    if (_fromPlatform != null) {
      return _fromPlatform;
    }

    Map<String, dynamic> map = await _Channel.invokeMapMethod<String, dynamic>('getAll');
    _fromPlatform = DeviceModel.fromMap(map);
    return _fromPlatform;
  }

  @visibleForTesting
  static void clearMockBcDevicePlugin() {
    _Channel.setMockMethodCallHandler(null);
  }

  @visibleForTesting
  static void setMockBcDevicePlugin() {
    _Channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getAll':
          return <String, dynamic>{
            'appName': 'Device Info',
            'appPackageName': 'co.com.example.datadevice.plugin',
            'appVersion': '1.0.0',
            'appBuildNumber': '1',
            'isPhysicalDevice': 'true',
            'deviceUUID': 'B488BBB56-4219-45E3-980B-7FA0BA7AD421',
            'deviceVersion': '12.5.1',
            'deviceSdk': '12.5.1',
            'deviceBrand': 'iPhone',
            'deviceManufacturer': 'iPhone',
            'deviceModel': 'iPhone 6',
            'deviceBaseOS': 'Darwin Kernel Versión',
            'deviceIpAddress': '100.106.91.138',
          };
        default:
          assert(false);
          return null;
      }
    });
  }
}
