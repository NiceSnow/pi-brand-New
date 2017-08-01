//
//  companyContentTableViewCell.h
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyContentModel.h"
#import "shareModel.h"

@interface companyContentTableViewCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
-(void)addDataWith:(companyContentModel*)headerModle;
-(void)ActiveaddDataWith:(companyContentModel*)headerModle;
@property(nonatomic,strong) shareModel* shareModel;
@end
