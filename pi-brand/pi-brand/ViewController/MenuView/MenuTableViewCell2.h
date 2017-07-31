//
//  MenuTableViewCell2.h
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/26.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell2 : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
-(void)addDataWithArray:(NSArray*)arr;
@end
