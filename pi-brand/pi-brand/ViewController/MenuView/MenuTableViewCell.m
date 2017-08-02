//
//  MenuTableViewCell.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/26.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "MenuTableViewCell.h"

@interface MenuTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation MenuTableViewCell

-(void)addDataWithUrlString:(lsitModel*)modle imageNamed:(NSString*)name;{
    if (name) {
        _headerImageView.image = [UIImage imageNamed:name];
    }else
        if (modle.nav_img.length>0) {
            [_headerImageView sd_setImageWithURL:[modle.nav_img safeUrlString] placeholderImage:nil];
        }
    
}

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"MenuTableViewCell";
    MenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[MenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MenuTableViewCell" owner:self options:nil]lastObject];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth*3/5);
            make.height.mas_equalTo((screenWidth*3/5)*21/180);
        }];
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
