package com.example.datadevice_plugin;

import androidx.annotation.NonNull;

import android.content.Context;
import android.content.pm.FeatureInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/** DatadevicePlugin */
public class DatadevicePlugin implements FlutterPlugin, MethodCallHandler {
  private Context applicationContext;
  private MethodChannel methodChannel;

  /** Plugin registration. */
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    final DatadevicePlugin instance = new DatadevicePlugin();
    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  public void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    methodChannel = new MethodChannel(messenger, "datadevice_plugin");
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    applicationContext = null;
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    try {
      if (call.method.equals("getAll")) {
        PackageManager pm = applicationContext.getPackageManager();
        PackageInfo info = pm.getPackageInfo(applicationContext.getPackageName(), 0);

        Map<String, Object> map = new HashMap<>();
        map.put("appName", info.applicationInfo.loadLabel(pm).toString());
        map.put("appPackageName", applicationContext.getPackageName());
        map.put("appVersion", info.versionName);
        map.put("appBuildNumber", String.valueOf(getLongVersionCode(info)));
        map.put("isPhysicalDevice", isEmulator());
        map.put("deviceUUID", getAndroidId());
        map.put("deviceVersion", Build.VERSION.RELEASE);
        map.put("deviceSdk", String.valueOf(Build.VERSION.SDK_INT));
        map.put("deviceBrand", Build.BRAND);
        map.put("deviceManufacturer", Build.MANUFACTURER);
        map.put("deviceModel", Build.MODEL);
        map.put("deviceIpAddress", getIPAddress());
        map.put("deviceSystemFeatures", Arrays.asList(getSystemFeatures()));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
          map.put("deviceBaseOS", Build.VERSION.BASE_OS);
        }

        result.success(map);
      } else {
        result.notImplemented();
      }
    } catch (PackageManager.NameNotFoundException ex) {
      result.error("Name not found", ex.getMessage(), null);
    }
  }

  @SuppressWarnings("deprecation")
  private static long getLongVersionCode(PackageInfo info) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
      return info.getLongVersionCode();
    }
    return info.versionCode;
  }

  private String getAndroidId() {
    return Settings.Secure.getString(applicationContext.getContentResolver(),
            Settings.Secure.ANDROID_ID);
  }

  private String isEmulator() {
    return ((Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
            || Build.FINGERPRINT.startsWith("generic")
            || Build.FINGERPRINT.startsWith("unknown")
            || Build.HARDWARE.contains("goldfish")
            || Build.HARDWARE.contains("ranchu")
            || Build.MODEL.contains("google_sdk")
            || Build.MODEL.contains("Emulator")
            || Build.MODEL.contains("Android SDK built for x86")
            || Build.MANUFACTURER.contains("Genymotion")
            || Build.PRODUCT.contains("sdk_google")
            || Build.PRODUCT.contains("google_sdk")
            || Build.PRODUCT.contains("sdk")
            || Build.PRODUCT.contains("sdk_x86")
            || Build.PRODUCT.contains("vbox86p")
            || Build.PRODUCT.contains("emulator")
            || Build.PRODUCT.contains("simulator"))? "false" : "true";
  }

  private String[] getSystemFeatures() {
    PackageManager pm = applicationContext.getPackageManager();
    FeatureInfo[] featureInfos = pm.getSystemAvailableFeatures();
    if (featureInfos == null) {
      return new String[] {};
    }

    String[] features = new String[featureInfos.length];
    for (int i = 0; i < featureInfos.length; i++) {
      features[i] = featureInfos[i].name;
    }
    return features;
  }

  private String getIPAddress() {
    String defultIp = "127.0.0.1";
    try {
      List<NetworkInterface> interfaces = Collections.list(NetworkInterface.getNetworkInterfaces());
      for (NetworkInterface item : interfaces) {
        List<InetAddress> addrs = Collections.list(item.getInetAddresses());
        for (InetAddress addr : addrs) {
          if (!addr.isLoopbackAddress()) {
            String sAddr = addr.getHostAddress();
            boolean isIPv4 = sAddr.indexOf(':') < 0;
            if (isIPv4)
              return sAddr;
          }
        }
      }

      return defultIp;
    } catch (Exception e) {
      return defultIp;
    }
  }

}
