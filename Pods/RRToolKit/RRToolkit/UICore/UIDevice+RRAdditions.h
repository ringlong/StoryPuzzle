//
//  UIDevice+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 3/19/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_2G_NAMESTRING            @"iPhone 2G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5C_NAMESTRING            @"iPhone 5C"
#define IPHONE_5S_NAMESTRING            @"iPhone 5S"
#define IPHONE_6_NAMESTRING             @"iPhone 6"
#define IPHONE_6P_NAMESTRING            @"iPhone 6 Plus"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1"
#define IPAD_2G_NAMESTRING              @"iPad 2"
#define IPAD_3G_NAMESTRING              @"iPad 3"
#define IPAD_4G_NAMESTRING              @"iPad 4"
#define IPAD_AIR_NAMESTRING             @"iPad Air"
#define IPAD_AIR_2_NAMESTRING           @"iPad Air 2"
#define IPAD_MINI_1_NAMESTRING          @"iPad Mini 1G"
#define IPAD_MINI_2_NAMESTRING          @"iPad Mini 2G"
#define IPAD_MINI_3_NAMESTRING          @"iPad Mini 3G"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator"

typedef NS_ENUM(NSInteger, UIDevicePlatform) {
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDeviceiPhone2G,
    UIDeviceiPhone3G,
    UIDeviceiPhone3GS,
    UIDeviceiPhone4,
    UIDeviceiPhone4S,
    UIDeviceiPhone5,
    UIDeviceiPhone5C,
    UIDeviceiPhone5S,
    UIDeviceiPhone6,
    UIDeviceiPhone6P,
    
    UIDeviceiPod1G,
    UIDeviceiPod2G,
    UIDeviceiPod3G,
    UIDeviceiPod4G,
    UIDeviceiPod5G,
    
    UIDeviceiPad1G,
    UIDeviceiPad2G,
    UIDeviceiPad3G,
    UIDeviceiPad4G,
    UIDeviceiPadAir,
    UIDeviceiPadAir2,
    UIDeviceiPadMini1,
    UIDeviceiPadMini2,
    UIDeviceiPadMini3,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA
};

typedef NS_ENUM(NSInteger, UIDeviceFamily) {
    UIDeviceFamilyUnknown,
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilySimulator
};

typedef NS_ENUM(NSUInteger, UIDeviceCarrier) {
    UIDeviceCarrierCMCC = 1,
    UIDeviceCarrierChinaUnicom,
    UIDeviceCarrierChinaTelecom,
    UIDeviceCarrierUnkonw,
};

UIKIT_EXTERN CGAffineTransform rotateTransformForOrientation(UIInterfaceOrientation orientation);

@interface UIDevice (RRAdditions)
@property (nonatomic, readonly) UIDeviceOrientation deviceOrientation; // Get current device orientation.
@property (nonatomic, readonly) BOOL isLandscape; // Determines if current device is in landscape state.
@property (nonatomic, readonly) BOOL isPortrait; // Determines if current device is in portrait state.
@property (nonatomic, readonly) NSString *orientationString; // Get current device orientation string.
+ (NSString *)orientationString:(UIDeviceOrientation)orientation; // Convert UIDeviceOrientation to orientation string. 
+ (BOOL)isJailBroken; // Determines if the device jail broken.
- (BOOL)isPad; // Determines if the device is iPad.
- (BOOL)isPhoneSupported; // Determines if the device has phone capabilities.


// The following Copied and pasted from https://github.com/erica
- (NSString *)platform;
- (NSString *)hwmodel;
- (UIDevicePlatform)platformType;
- (NSString *)platformString;

- (NSUInteger)cpuFrequency;
- (NSUInteger)busFrequency;
- (NSUInteger)cpuCount;
- (NSUInteger)totalMemory;
- (NSUInteger)userMemory;

- (NSNumber *)totalDiskSpace;
- (NSNumber *)freeDiskSpace;

- (NSString *)macaddress NS_DEPRECATED_IOS(2_0,7_0); // iOS 7 will return the same static value for all devices.

- (BOOL)hasRetinaDisplay;
- (UIDeviceFamily)deviceFamily;

+ (UIDeviceCarrier)currentCarrierName;


@end
