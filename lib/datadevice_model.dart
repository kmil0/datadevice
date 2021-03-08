class DeviceModel {
  final String appName;
  final String appPackageName;
  final String appVersion;
  final String appBuildNumber;
  final bool isPhysicalDevice;
  final String deviceUUID;
  final String deviceVersion;
  final String deviceSdk;
  final String deviceBrand;
  final String deviceManufacturer;
  final String deviceModel;
  final String deviceBaseOS;
  final String deviceIpAddress;
  final List<String> deviceSystemFeatures;

  DeviceModel({
    this.appName,
    this.appPackageName,
    this.appVersion,
    this.appBuildNumber,
    this.isPhysicalDevice,
    this.deviceUUID,
    this.deviceVersion,
    this.deviceSdk,
    this.deviceBrand,
    this.deviceManufacturer,
    this.deviceModel,
    this.deviceBaseOS,
    this.deviceIpAddress,
    this.deviceSystemFeatures,
  });

  static fromMap(Map<String, dynamic> map) => DeviceModel(
    appName: map["appName"],
    appPackageName: map["appPackageName"],
    appVersion: map["appVersion"],
    appBuildNumber: map["appBuildNumber"],
    isPhysicalDevice: (map["isPhysicalDevice"] == 'true'),
    deviceUUID: map["deviceUUID"],
    deviceVersion: map["deviceVersion"],
    deviceSdk: map["deviceSdk"],
    deviceBrand: map["deviceBrand"],
    deviceManufacturer: map["deviceManufacturer"],
    deviceModel: map["deviceModel"],
    deviceBaseOS: map["deviceBaseOS"],
    deviceIpAddress: map["deviceIpAddress"],
    deviceSystemFeatures: _fromList(map["deviceSystemFeatures"] ?? []),
  );

  static List<String> _fromList(dynamic message) {
    List<dynamic> list = message;
    return List<String>.from(list);
  }
}