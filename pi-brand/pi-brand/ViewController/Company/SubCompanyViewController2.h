//
//  SubCompanyViewController2.h
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyHeaderModel.h"
#import "subModel2.h"

@interface SubCompanyViewController2 : UITableViewController
@property (nonatomic, strong) companyHeaderModel* headModel;
@property (nonatomic, strong) NSArray<subModel2*>* res;
@end
