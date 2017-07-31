//
//  MenuTableViewCell.h
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/26.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lsitModel.h"

@interface MenuTableViewCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
-(void)addDataWithUrlString:(lsitModel*)modle imageNamed:(NSString*)name;
@end
