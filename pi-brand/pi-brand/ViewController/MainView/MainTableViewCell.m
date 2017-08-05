//
//  MainTableViewCell.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *secTitle;

@end

@implementation MainTableViewCell

-(void)addDataWithModel:(mainModle*)model;{
    if (model.vice_img.length>0) {
        [_titleImage sd_setImageWithURL:[model.vice_img safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:_titleImage duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _titleImage.alpha = 1;
            } completion:nil];
        }];
    }
    if (model.img.length>0) {
        [_mainImage sd_setImageWithURL:[model.img safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:_mainImage duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _mainImage.alpha = 1;
            } completion:nil];
        }];
    }
    
    _mainTitle.text = model.title;
    _secTitle.text = model.vice_heading;
}

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"MainTableViewCell";
    MainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MainTableViewCell" owner:self options:nil]lastObject];
        [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((screenWidth-40)*4/5);
            make.height.mas_equalTo((screenWidth-40)*4/5*105/232);
        }];
        [_mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth-50);
            make.height.mas_equalTo((screenWidth-50)*9/10*187/291);
        }];
        _titleImage.alpha = 0;
        _mainImage.alpha = 0;
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
