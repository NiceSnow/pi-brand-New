//
//  CompanyHeaderTableViewCell.h
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyHeaderModel.h"

@interface CompanyHeaderTableViewCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
-(void)addDataWith:(companyHeaderModel*)headerModle;
@end
