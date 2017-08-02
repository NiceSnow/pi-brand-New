//
//  SearchTableViewCell.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *secTitle;

@end

@implementation SearchTableViewCell

-(void)addDataWithModel:(searchModel*)modle;{
    if (modle.img.length>0) {
        [_headerImage sd_setImageWithURL:[modle.img safeUrlString] placeholderImage:nil];
    }
    
    _mainTitle.text = modle.title;
    _secTitle.text = modle.vice_heading;
}

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"SearchTableViewCell";
    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:self options:nil]lastObject];
        [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth/3);
            make.height.mas_equalTo(screenWidth/3*249/384);
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
