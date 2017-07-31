//
//  Product3Cell.h
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product3Cell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)NSDictionary* dict;

@end
