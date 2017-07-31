//
//  Product3Cell.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Product3Cell.h"


@interface Product3Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation Product3Cell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"Product3Cell";
    Product3Cell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[Product3Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"Product3Cell" owner:self options:nil]lastObject];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.height.mas_equalTo((screenWidth-20)*9/10*187/291);
        }];
        _contentLabel.numberOfLines = 2;
    }
    return self;
}
- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [_backImageView sd_setImageWithURL:[dict[@"img"] safeUrlString]];
    _titleLabel.text = dict[@"title"];
    _contentLabel.text =  dict[@"vice_heading"];
}
@end
