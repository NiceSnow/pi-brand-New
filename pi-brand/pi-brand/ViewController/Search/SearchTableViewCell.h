//
//  SearchTableViewCell.h
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchModel.h"

@interface SearchTableViewCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
-(void)addDataWithModel:(searchModel*)modle;
@end
