//
//  SubCompanyViewController1.h
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyHeaderModel.h"
#import "companyContentModel.h"
#import "shareModel.h"


@interface SubCompanyViewController1 : UITableViewController
@property (nonatomic, strong) companyHeaderModel* headModel;
@property (nonatomic, strong) companyContentModel* contentModel;
@property(nonatomic,strong) shareModel* shareModel;
@end
