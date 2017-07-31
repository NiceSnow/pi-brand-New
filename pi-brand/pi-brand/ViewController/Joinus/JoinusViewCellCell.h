//
//  JoinusViewCellCell.h
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinusViewCellCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSArray* dataArray;

@end
