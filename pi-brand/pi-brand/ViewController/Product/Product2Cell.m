//
//  Product2Cell.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Product2Cell.h"


@interface Product2Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation Product2Cell


+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"Product2Cell";
    Product2Cell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[Product2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"Product2Cell" owner:self options:nil]lastObject];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.height.mas_equalTo((screenWidth-20)*9/10*187/291);
        }];
    }
    return self;
}
- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [_backImageView sd_setImageWithURL:[dict[@"store_img"] safeUrlString]];
    _titleLabel.text = dict[@"store_name"];
}

@end
