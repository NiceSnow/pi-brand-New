//
//  DefineClass.h
//  YLHospital_2.0
//
//  Created by AMed on 15/11/12.
//  Copyright © 2015年 博睿精实. All rights reserved.
//

#ifndef DefineClass_h
#define DefineClass_h




#endif /* DefineClass_h */

#define DOCPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"]
//测试
//#define testWithURL(url) [@"http://test.api.drresource.com/v1/" stringByAppendingString:url]
//生产
#define testWithURL(url) [@"http://api.drresource.com/v1/" stringByAppendingString:url]

/**
 debug版本输出查看信息
 */


#ifdef DEBUG
#define DebugLog(format, ...) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__] )
#else
#define DebugLog(format, ...)
#endif

//#ifdef DEBUG
//#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define DebugLog( s, ... )
//#endif

/**
 版本号
 */
#define TheVersionNumber [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 NavBar高度
 */
#define NavigationBar_HEIGHT 64

/**
 tabbar高度
 */
#define Tabbar_HEIGHT 49
/**
 系统版本号
 */
#define systemValue [[[UIDevice currentDevice] systemVersion] floatValue]
/**
 这个View的宽高
 */
#define selfWidth   self.frame.size.height
#define selfHeight    self.frame.size.width
/**
 屏幕的宽高和大小
 */
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenBounds [UIScreen mainScreen].bounds
/**
 沙盒路径
 */
#define kDocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define versionKey  (NSString *)kCFBundleVersionKey
#define oldVersion [[NSUserDefaults standardUserDefaults] objectForKey:versionKey]
#define newVersion [NSBundle mainBundle].infoDictionary[versionKey]
#define showNewFeature  ![oldVersion isEqualToString:newVersion]
#define UserDefault [NSUserDefaults standardUserDefaults]
#define WS(weakSelf)     __weak typeof(self) weakSelf = self;

#define HeaderImage [kDocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[UserHelper instance].UID]]
#define headerURL @"headerURL"
/**
 UserDefault
 */
#define UserDefault [NSUserDefaults standardUserDefaults]

#define UserInfo @"userInfo"
#define UserID @"uid"
/**
 16进制颜色以及透明度
 */
#define UICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]
/**
 RGB颜色以及透明度
 */
#define RGBCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define kRedColor       UICOLOR_RGB_Alpha(0xd81e06,1)
#define kGrayColor      UICOLOR_RGB_Alpha(0xdbdbdb,1)
#define kYellowColor    UICOLOR_RGB_Alpha(0xf4c900,1)

#define kOrangeColor    UICOLOR_RGB_Alpha(0xee8e38,1)
#define kLineColor      UICOLOR_RGB_Alpha(0xbfbfbf,1)
#define k5c5c5cColor    UICOLOR_RGB_Alpha(0x5c5c5c,1)
#define k4a4a4aColor    UICOLOR_RGB_Alpha(0x4a4a4a,1)
#define k4c4c4cColor    UICOLOR_RGB_Alpha(0x4c4c4c,1)
#define ka6a6a6Color    UICOLOR_RGB_Alpha(0xa6a6a6,1)
#define kGreenColor     UICOLOR_RGB_Alpha(0x65ca57,1)
#define kc1c1c1Color    UICOLOR_RGB_Alpha(0xc1c1c1,1)
#define kbababaColor    UICOLOR_RGB_Alpha(0xbababa,1)

#define openScreen [[UIApplication sharedApplication] setIdleTimerDisabled:YES]
#define closeScreen [[UIApplication sharedApplication] setIdleTimerDisabled:NO]
/**
 定义UIImage对象
 */
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer］

/**
 字符串是否为空
 */
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

/**
 数组是否为空
 */
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

/**
 字典是否为空
 */
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

/**
 是否是空对象
 */
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

typedef enum : NSUInteger {
    kCollectionViewMain,//首页
    kCollectionViewAcssets,//资产
    kCollectionViewMine,//个人中心
} kCollectionViewType;

//判断设备型号
#define UI_IS_LANDSCAPE         ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
#define UI_IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS       (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations


