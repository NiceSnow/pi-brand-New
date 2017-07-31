//
//  ActiveTableViewCell.h
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/29.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subModel2.h"

@interface ActiveTableViewCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
-(void)addDataWith:(subModel2*)modle;
@end
