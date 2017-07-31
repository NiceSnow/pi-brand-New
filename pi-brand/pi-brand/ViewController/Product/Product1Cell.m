//
//  Product1Cell.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Product1Cell.h"

@interface Product1Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImanegView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
@implementation Product1Cell


+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"Product1Cell";
    Product1Cell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[Product1Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"Product1Cell" owner:self options:nil]lastObject];
         [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.mas_equalTo(screenWidth-100);
         }];
    }
    return self;
}
- (void)setImageString:(NSString *)imageString
{
    _imageString = imageString;
    _iconImanegView.image = [UIImage imageNamed:imageString];
}
- (void)setContentString:(NSString *)contentString
{
    _contentString = contentString;
    _contentLabel.text = contentString;
}

@end
