//
//  JoinusViewCellCell.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "JoinusViewCellCell.h"
#import "companyHeaderModel.h"
#import "joinMainModel.h"


@interface JoinusViewCellCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@end
@implementation JoinusViewCellCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"JoinusViewCellCell";
    JoinusViewCellCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[JoinusViewCellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JoinusViewCellCell" owner:self options:nil]lastObject];
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(screenWidth*320/750);
            make.height.mas_offset((screenWidth*320/750)*35/320);
        }];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((screenWidth-40)*4/5);
        make.height.mas_equalTo((screenWidth-40)*4/5*105/232);
        }];
    
        [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth-50);
            make.height.mas_equalTo((screenWidth-50)*9/10*187/291);
        }];
        _logoImageView.alpha = 0;
        _iconImageView.alpha = 0;
        _mainImageView.hidden = 0;
        
    }
    return self;
}
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    companyHeaderModel* model = dataArray[0];
    
    joinMainModel* mainModel = dataArray[1];
    if (model.icon.length>0) {
        [_logoImageView sd_setImageWithURL:[model.icon safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:_logoImageView duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _logoImageView.alpha = 1;
            } completion:nil];
        }];
    }
    if (model.image.length>0) {
        [_iconImageView sd_setImageWithURL:[model.image safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:_iconImageView duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _iconImageView.alpha = 1;
            } completion:nil];
        }];
    }
    
    _desLabel.text = model.title;
    if (mainModel.img.length>0) {
        
        [_mainImageView sd_setImageWithURL:[mainModel.img safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:_mainImageView duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _mainImageView.alpha = 1;
            } completion:nil];
        }];
    }
    
    _titleLabel.text = mainModel.title;
    _contentLabel.text = mainModel.vice_heading;
    
}
@end
