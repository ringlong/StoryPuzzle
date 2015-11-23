//
//  UIDevice+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 3/19/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "UIDevice+RRAdditions.h"
#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "RRPreprocessorMacros.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

RR_FIX_CATEGORY_BUG(UIDeviceEYAdditions)

CGAffineTransform rotateTransformForOrientation(UIInterfaceOrientation orientation) {
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI * 1.5);
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI_2);
        
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
        
    } else {
        return CGAffineTransformIdentity;
    }
}

@implementation UIDevice (RRAdditions)
@dynamic deviceOrientation, isLandscape, isPortrait, orientationString;

#pragma mark - Basic orientation

- (UIDeviceOrientation)deviceOrientation {
    UIDeviceOrientation orient = self.orientation;
    if (UIDeviceOrientationUnknown == orient) {
        return UIDeviceOrientationPortrait;
    } else {
        return orient;
    }
}

- (BOOL)isLandscape {
	return UIDeviceOrientationIsLandscape(self.deviceOrientation);
}

- (BOOL)isPortrait {
	return UIDeviceOrientationIsPortrait(self.deviceOrientation);
}

- (NSString *)orientationString {
    return [UIDevice orientationString:self.deviceOrientation];
}

+ (NSString *)orientationString:(UIDeviceOrientation)orientation {
	switch (orientation) {
		case UIDeviceOrientationUnknown: return @"Unknown";
		case UIDeviceOrientationPortrait: return @"Portrait";
		case UIDeviceOrientationPortraitUpsideDown: return @"Portrait Upside Down";
		case UIDeviceOrientationLandscapeLeft: return @"Landscape Left";
		case UIDeviceOrientationLandscapeRight: return @"Landscape Right";
		case UIDeviceOrientationFaceUp: return @"Face Up";
		case UIDeviceOrientationFaceDown: return @"Face Down";
		default: break;
	}
	return nil;
}

- (BOOL)isPad {
#ifdef __IPHONE_3_2
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}

- (BOOL)isPhoneSupported {
    return [self.model isEqualToString:@"iPhone"];
}

+ (BOOL)isJailBroken
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
	static const char * jailBrokenApps[] = {
		"/Application/Cydia.app",
		"/Application/limera1n.app",
		"/Application/greenpois0n.app",
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
		NULL
	};
    
	// method 1
    for ( int i = 0; jailBrokenApps[i]; ++i ) {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailBrokenApps[i]]] )
        {
			return YES;
        }
    }
	
    // method 2
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ) {
		return YES;
	}
	
	// method 3
	if ( 0 == system("ls") ) {
		return YES;
	}
	
    return NO;
#endif
}




#pragma mark - Sysctlbyname utils
- (NSString *)getSysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *)platform {
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *)hwmodel {
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark - Sysctl utils
- (NSUInteger)getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger)cpuFrequency {
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger)busFrequency {
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger)cpuCount {
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger)totalMemory {
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger)userMemory {
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger)maxSocketBufferSize {
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark File system
/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */
- (NSNumber *)totalDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *)freeDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark Platform type and name utils
- (UIDevicePlatform)platformType {
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDeviceiPhone2G;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDeviceiPhone3G;
    if ([platform hasPrefix:@"iPhone2"])            return UIDeviceiPhone3GS;
    if ([platform hasPrefix:@"iPhone3"])            return UIDeviceiPhone4;
    if ([platform hasPrefix:@"iPhone4"])            return UIDeviceiPhone4S;
    if ([platform isEqualToString:@"iPhone5,1"])    return UIDeviceiPhone5;
    if ([platform isEqualToString:@"iPhone5,2"])    return UIDeviceiPhone5;
    if ([platform isEqualToString:@"iPhone5,3"])    return UIDeviceiPhone5C;
    if ([platform isEqualToString:@"iPhone5,4"])    return UIDeviceiPhone5C;
    if ([platform hasPrefix:@"iPhone6"])            return UIDeviceiPhone5S;
    if ([platform isEqualToString:@"iPhone7,1"])    return UIDeviceiPhone6P;
    if ([platform isEqualToString:@"iPhone7,2"])    return UIDeviceiPhone6;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDeviceiPod1G;
    if ([platform hasPrefix:@"iPod2"])              return UIDeviceiPod2G;
    if ([platform hasPrefix:@"iPod3"])              return UIDeviceiPod3G;
    if ([platform hasPrefix:@"iPod4"])              return UIDeviceiPod4G;
    if ([platform hasPrefix:@"iPod5"])              return UIDeviceiPod5G;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDeviceiPad1G;
    if ([platform isEqualToString:@"iPad2,1"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,2"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,3"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,4"])      return UIDeviceiPad2G;
    if ([platform isEqualToString:@"iPad2,5"])      return UIDeviceiPadMini1;
    if ([platform isEqualToString:@"iPad2,6"])      return UIDeviceiPadMini1;
    if ([platform isEqualToString:@"iPad2,7"])      return UIDeviceiPadMini1;
    if ([platform isEqualToString:@"iPad3,1"])      return UIDeviceiPad3G;
    if ([platform isEqualToString:@"iPad3,2"])      return UIDeviceiPad3G;
    if ([platform isEqualToString:@"iPad3,3"])      return UIDeviceiPad3G;
    if ([platform isEqualToString:@"iPad3,4"])      return UIDeviceiPad4G;
    if ([platform isEqualToString:@"iPad3,5"])      return UIDeviceiPad4G;
    if ([platform isEqualToString:@"iPad3,6"])      return UIDeviceiPad4G;
    if ([platform isEqualToString:@"iPad4,1"])      return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,2"])      return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,3"])      return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,4"])      return UIDeviceiPadMini2;
    if ([platform isEqualToString:@"iPad4,5"])      return UIDeviceiPadMini2;
    if ([platform isEqualToString:@"iPad4,6"])      return UIDeviceiPadMini2;
    if ([platform isEqualToString:@"iPad4,7"])      return UIDeviceiPadMini3;
    if ([platform isEqualToString:@"iPad4,8"])      return UIDeviceiPadMini3;
    if ([platform isEqualToString:@"iPad4,9"])      return UIDeviceiPadMini3;
    if ([platform isEqualToString:@"iPad5,3"])      return UIDeviceiPadAir2;
    if ([platform isEqualToString:@"iPad5,4"])      return UIDeviceiPadAir2;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (NSString *)platformString {
    switch ([self platformType])
    {
        case UIDeviceiPhone2G: return IPHONE_2G_NAMESTRING;
        case UIDeviceiPhone3G: return IPHONE_3G_NAMESTRING;
        case UIDeviceiPhone3GS: return IPHONE_3GS_NAMESTRING;
        case UIDeviceiPhone4: return IPHONE_4_NAMESTRING;
        case UIDeviceiPhone4S: return IPHONE_4S_NAMESTRING;
        case UIDeviceiPhone5: return IPHONE_5_NAMESTRING;
        case UIDeviceiPhone5C: return IPHONE_5C_NAMESTRING;
        case UIDeviceiPhone5S: return IPHONE_5S_NAMESTRING;
        case UIDeviceiPhone6: return IPHONE_6_NAMESTRING;
        case UIDeviceiPhone6P: return IPHONE_6P_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDeviceiPod1G: return IPOD_1G_NAMESTRING;
        case UIDeviceiPod2G: return IPOD_2G_NAMESTRING;
        case UIDeviceiPod3G: return IPOD_3G_NAMESTRING;
        case UIDeviceiPod4G: return IPOD_4G_NAMESTRING;
        case UIDeviceiPod5G: return IPOD_5G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDeviceiPad1G: return IPAD_1G_NAMESTRING;
        case UIDeviceiPad2G: return IPAD_2G_NAMESTRING;
        case UIDeviceiPad3G: return IPAD_3G_NAMESTRING;
        case UIDeviceiPad4G: return IPAD_4G_NAMESTRING;
        case UIDeviceiPadAir: return IPAD_AIR_NAMESTRING;
        case UIDeviceiPadAir2: return IPAD_AIR_2_NAMESTRING;
        case UIDeviceiPadMini1: return IPAD_MINI_1_NAMESTRING;
        case UIDeviceiPadMini2: return IPAD_MINI_2_NAMESTRING;
        case UIDeviceiPadMini3: return IPAD_MINI_3_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
        case UIDeviceAppleTV4 : return APPLETV_4G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        case UIDeviceSimulatorAppleTV: return SIMULATOR_APPLETV_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

- (BOOL)hasRetinaDisplay {
    return ([UIScreen mainScreen].scale == 2.0f);
}

- (UIDeviceFamily)deviceFamily {
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) return UIDeviceFamilySimulator;
    return UIDeviceFamilyUnknown;
}

+ (UIDeviceCarrier)currentCarrierName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *currentCarrier = networkInfo.subscriberCellularProvider;
    
    if (!currentCarrier || !currentCarrier.mobileNetworkCode) {
        // 模拟器取不到运营商或者手机未插卡或者iPod
        return UIDeviceCarrierUnkonw;
    }
    
    NSUInteger codeNum = currentCarrier.mobileNetworkCode.integerValue;
    NSString *carrierName = currentCarrier.carrierName;
    // 中国移动
    for (NSNumber *code in @[@0, @2, @7]) {
        if (code.integerValue == codeNum) {
            return UIDeviceCarrierCMCC;
        }
    }
    if ([carrierName isEqualToString:@"中国移动"]) {
        return UIDeviceCarrierCMCC;
    }
    // 中国联通
    for (NSNumber *code in @[@1, @6]) {
        if (code.integerValue == codeNum) {
            return UIDeviceCarrierChinaUnicom;
        }
    }
    if ([carrierName isEqualToString:@"中国联通"]) {
        return UIDeviceCarrierChinaUnicom;
    }
    // 中国电信
    for (NSNumber *code in @[@3, @5]) {
        if (code.integerValue == codeNum) {
            return UIDeviceCarrierChinaTelecom;
        }
    }
    if ([carrierName isEqualToString:@"中国电信"]) {
        return UIDeviceCarrierChinaTelecom;
    }
    
    return UIDeviceCarrierUnkonw;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *)macaddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

@end
