//
//  Product1Cell.h
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product1Cell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSString* imageString;
@property (nonatomic, strong)NSString* contentString;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *row;


@end
