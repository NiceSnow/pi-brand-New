//
//  CompanyHeaderTableViewCell.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "CompanyHeaderTableViewCell.h"

@interface CompanyHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *secTitle;

@end



@implementation CompanyHeaderTableViewCell

-(void)addDataWith:(companyHeaderModel*)headerModle;{
    if (headerModle.image.length>0) {
        [self.img sd_setImageWithURL:[headerModle.image safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:self.img duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.img.alpha = 1;
            } completion:nil];
        }];
    }
    self.secTitle.text = headerModle.title;
}

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"CompanyHeaderTableViewCell";
    CompanyHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[CompanyHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CompanyHeaderTableViewCell" owner:self options:nil]lastObject];
            [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((screenWidth-20)/2);
            make.height.mas_equalTo((screenWidth-20)/2*77.53/180);
        }];
        _img.alpha = 0;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
