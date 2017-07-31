//
//  ChildViewController.h
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/26.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNavigationController.h"
#import "MainViewController.h"
#import "WebViewController.h"
#import "JoinusViewController.h"
#import "CompanyViewController.h"
#import "ProductViewController.h"
#import "shopViewController.h"

@interface ChildViewController : NSObject
+ (ChildViewController *)instance;
@property(nonatomic,strong) BaseNavigationController* MainNavgation;
@property(nonatomic,strong) MainViewController* MainVC;
@property(nonatomic,strong) BaseNavigationController* WebNavgation;
@property(nonatomic,strong) WebViewController* webVC;
@property(nonatomic,strong) BaseNavigationController* joinNavgation;
@property(nonatomic,strong) JoinusViewController* joinVC;
@property(nonatomic,strong) BaseNavigationController* companyNavgation;
@property(nonatomic,strong) CompanyViewController* companyVC;
@property(nonatomic,strong) BaseNavigationController* productNavgation;
@property(nonatomic,strong) ProductViewController* productVC;
@property(nonatomic,strong) BaseNavigationController* shopNavgation;
@property(nonatomic,strong) shopViewController* shopVC;
@end
