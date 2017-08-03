//
//  ActiveViewController.h
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/29.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyHeaderModel.h"
#import "companyContentModel.h"
#import "shareModel.h"

@interface ActiveViewController : UIViewController
@property(nonatomic,copy) NSString* ID;
@property (nonatomic, copy) NSString* backImageString;
@property (nonatomic, strong) companyHeaderModel* headModle;
@property(nonatomic,strong)   companyContentModel* contentModel;
@property(nonatomic,strong) shareModel* shareModel;
@end
