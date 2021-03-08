import 'package:datadevice_plugin/datadevice_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:datadevice_plugin/datadevice_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    DatadevicePlugin.setMockBcDevicePlugin();
  });

  tearDown(() {
    DatadevicePlugin.clearMockBcDevicePlugin();
  });

  test('BcDevicePlugin Test', () async {
    DeviceModel info = await DatadevicePlugin.fromPlatform();
    expect(info.appName, 'BC Device Info');
    expect(info.appPackageName, 'co.com.bancolombia.galatea.plugin');
    expect(info.appVersion, '1.0.0');
    expect(info.appBuildNumber, '1');
    expect(info.isPhysicalDevice, true);
    expect(info.deviceUUID, 'B488BBB56-4219-45E3-980B-7FA0BA7AD421');
    expect(info.deviceVersion, '12.5.1');
    expect(info.deviceSdk, '12.5.1');
    expect(info.deviceBrand, 'iPhone');
    expect(info.deviceManufacturer, 'iPhone');
    expect(info.deviceModel, 'iPhone 6');
    expect(info.deviceBaseOS, 'Darwin Kernel Versión');
    expect(info.deviceIpAddress, '100.106.91.138');
    expect(info.deviceSystemFeatures, <dynamic>[]);
  });
}
