#import "DatadevicePlugin.h"
#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <SSKeychain/SSKeychain.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"

@implementation DatadevicePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"datadevice_plugin"
            binaryMessenger:[registrar messenger]];
  DatadevicePlugin* instance = [[DatadevicePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getAll" isEqualToString:call.method]) {
    UIDevice* device = [UIDevice currentDevice];
       NSBundle* bundle = [NSBundle mainBundle];
       struct utsname un;
       uname(&un);

       result(@{
         @"appName" : [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]?: [NSNull null],
         @"appPackageName" : [bundle bundleIdentifier] ?: [NSNull null],
         @"appVersion" : [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]?: [NSNull null],
         @"appBuildNumber" : [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]?: [NSNull null],
         @"isPhysicalDevice" : [self isDevicePhysical],
         @"deviceUUID" : [self getUuid],
         @"deviceVersion" : [device systemVersion],
         @"deviceSdk" : [device systemVersion],
         @"deviceBrand" : [device localizedModel],
         @"deviceManufacturer" : [device localizedModel],
         @"deviceModel" : [self getDeviceModel],
         @"deviceBaseOS" : @(un.version),
         @"deviceIpAddress" : [self getIPAddresss],
         //@"deviceSystemFeatures" : [self getIPAddresss],
       });
  } else {
    result(FlutterMethodNotImplemented);
  }
}
// return value is false if code is run on a simulator
- (NSString*)isDevicePhysical {
#if TARGET_OS_SIMULATOR
  NSString* isPhysicalDevice = @"false";
#else
  NSString* isPhysicalDevice = @"true";
#endif
  return isPhysicalDevice;
}

// return device uuid
- (NSString*)getUuid {
  NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
  NSString *applicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
  if (applicationUUID == nil)
  {
    applicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [SSKeychain setPassword:applicationUUID forService:appName account:@"incoding"];
  }

  return applicationUUID;
}

// return device uuid
- (NSString*)getDeviceModel {
  NSDictionary *d = @{
    @"iPod5,1" : @"iPod Touch 5",
    @"iPod7,1" : @"iPod Touch 6",
    @"iPod9,1" : @"iPod touch (7th generation)",
    @"iPhone5,1" : @"iPhone 5",
    @"iPhone5,2" : @"iPhone 5",
    @"iPhone5,3" : @"iPhone 5c",
    @"iPhone5,4" : @"iPhone 5c",
    @"iPhone6,1" : @"iPhone 5s",
    @"iPhone6,2" : @"iPhone 5s",
    @"iPhone7,2" : @"iPhone 6",
    @"iPhone7,1" : @"iPhone 6 Plus",
    @"iPhone8,1" : @"iPhone 6s",
    @"iPhone8,2" : @"iPhone 6s Plus",
    @"iPhone9,1" : @"iPhone 7",
    @"iPhone9,3" : @"iPhone 7",
    @"iPhone9,2" : @"iPhone 7 Plus",
    @"iPhone9,4" : @"iPhone 7 Plus",
    @"iPhone8,4" : @"iPhone SE",
    @"iPhone10,1" : @"iPhone 8",
    @"iPhone10,4" : @"iPhone 8",
    @"iPhone10,2" : @"iPhone 8 Plus",
    @"iPhone10,5" : @"iPhone 8 Plus",
    @"iPhone10,3" : @"iPhone X",
    @"iPhone10,6" : @"iPhone X",
    @"iPhone11,2" : @"iPhone XS",
    @"iPhone11,4" : @"iPhone XS Max",
    @"iPhone11,6" : @"iPhone XS Max",
    @"iPhone11,8" : @"iPhone XR",
    @"iPhone12,1" : @"iPhone 11",
    @"iPhone12,3" : @"iPhone 11 Pro",
    @"iPhone12,5" : @"iPhone 11 Pro Max",
    @"iPhone12,8" : @"iPhone SE (2nd generation)",
    @"iPhone13,1" : @"iPhone 12 mini",
    @"iPhone13,2" : @"iPhone 12",
    @"iPhone13,3" : @"iPhone 12 Pro",
    @"iPhone13,4" : @"iPhone 12 Pro Max",
    @"iPad2,1" : @"iPad 2",
    @"iPad2,2" : @"iPad 2",
    @"iPad2,3" : @"iPad 2",
    @"iPad2,4" : @"iPad 2",
    @"iPad3,1" : @"iPad 3",
    @"iPad3,2" : @"iPad 3",
    @"iPad3,3" : @"iPad 3",
    @"iPad3,4" : @"iPad 4",
    @"iPad3,5" : @"iPad 4",
    @"iPad3,6" : @"iPad 4",
    @"iPad4,1" : @"iPad Air",
    @"iPad4,2" : @"iPad Air",
    @"iPad4,3" : @"iPad Air",
    @"iPad5,3" : @"iPad Air 2",
    @"iPad5,4" : @"iPad Air 2",
    @"iPad6,11" : @"iPad 5",
    @"iPad6,12" : @"iPad 5",
    @"iPad7,5" : @"iPad 6",
    @"iPad7,6" : @"iPad 6",
    @"iPad2,5" : @"iPad Mini",
    @"iPad2,6" : @"iPad Mini",
    @"iPad2,7" : @"iPad Mini",
    @"iPad4,4" : @"iPad Mini 2",
    @"iPad4,5" : @"iPad Mini 2",
    @"iPad4,6" : @"iPad Mini 2",
    @"iPad4,7" : @"iPad Mini 3",
    @"iPad4,8" : @"iPad Mini 3",
    @"iPad4,9" : @"iPad Mini 3",
    @"iPad5,1" : @"iPad Mini 4",
    @"iPad5,2" : @"iPad Mini 4",
    @"iPad6,3" : @"iPad Pro 9.7 Inch",
    @"iPad6,4" : @"iPad Pro 9.7 Inch",
    @"iPad6,7" : @"iPad Pro 12.9 Inch",
    @"iPad6,8" : @"iPad Pro 12.9 Inch",
    @"iPad7,1" : @"iPad Pro (12.9-inch) (2nd generation)",
    @"iPad7,2" : @"iPad Pro (12.9-inch) (2nd generation)",
    @"iPad7,3" : @"iPad Pro (10.5-inch)",
    @"iPad7,4" : @"iPad Pro (10.5-inch)",
    @"iPad8,1" : @"iPad Pro (11-inch)",
    @"iPad8,2" : @"iPad Pro (11-inch)",
    @"iPad8,3" : @"iPad Pro (11-inch)",
    @"iPad8,4" : @"iPad Pro (11-inch)",
    @"iPad8,5" : @"iPad Pro (12.9-inch) (3rd generation)",
    @"iPad8,6" : @"iPad Pro (12.9-inch) (3rd generation)",
    @"iPad8,7" : @"iPad Pro (12.9-inch) (3rd generation)",
    @"iPad8,8" : @"iPad Pro (12.9-inch) (3rd generation)",
    @"iPad8,11" : @"iPad Pro (12.9-inch) (4th generation)",
    @"iPad8,12" : @"iPad Pro (12.9-inch) (4th generation)",
  };

  struct utsname un;
  uname(&un);
  NSString *input = @(un.machine);
  NSString *data = d[input];
  if (data == nil)
    data = input;

  return data;
}

- (NSString*)getIPAddresss {
    NSArray *wifiSearchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv4 ];
    NSArray *dataSearchArray = @[ IOS_CELLULAR @"/" IP_ADDR_IPv4 ];
    NSDictionary *addresses = [self getIPAddresses];

    __block NSString *wifiAddress;
    __block NSString *dataAddress;

    [wifiSearchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        wifiAddress = addresses[key];
        if(wifiAddress) *stop = YES;
    }];

    [dataSearchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        dataAddress = addresses[key];
        if(dataAddress) *stop = YES;
    }];

    if (dataAddress != nil) {
        return dataAddress;
    }

    if (wifiAddress != nil) {
        return wifiAddress;
    }

    return @"127.0.0.1";
}

// return ip addressess
- (NSDictionary*)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end

