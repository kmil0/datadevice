import 'package:datadevice_plugin/datadevice_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:datadevice_plugin/datadevice_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PluginInfo Demo",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DeviceModel _packageInfo;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    DeviceModel info = await DatadevicePlugin.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle ?? 'Not set'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Info Example'),
      ),
      body: ListView(
        children: _getSystemList(),
      ),
    );
  }

  List<Widget> _getSystemList() {
    List<Widget> elements = [];
    elements.add(_infoTile('App name', _packageInfo?.appName));
    elements.add(_infoTile('App Package name', _packageInfo?.appPackageName));
    elements.add(_infoTile('App version', _packageInfo?.appVersion));
    elements.add(_infoTile('App build number', _packageInfo?.appBuildNumber));
    elements.add(_infoTile('is Physical Device',
        _packageInfo?.isPhysicalDevice.toString()));
    elements.add(_infoTile('Device UUID', _packageInfo?.deviceUUID));
    elements.add(_infoTile('Device version', _packageInfo?.deviceVersion));
    elements.add(_infoTile('Device SdkInt', _packageInfo?.deviceSdk));
    elements.add(_infoTile('Device Brand', _packageInfo?.deviceBrand));
    elements.add(_infoTile('Device Manufacturer',
        _packageInfo?.deviceManufacturer));
    elements.add(_infoTile('Device Model', _packageInfo?.deviceModel));
    elements.add(_infoTile('Device BaseOS', _packageInfo?.deviceBaseOS));
    elements.add(_infoTile('Device IpAddress', _packageInfo?.deviceIpAddress));
    elements.add(_infoTile('deviceSystemFeatures', ''));

    _packageInfo?.deviceSystemFeatures?.forEach((String item) =>
        elements.add(Text(item ?? ''))
    );

    return elements;
  }
}
