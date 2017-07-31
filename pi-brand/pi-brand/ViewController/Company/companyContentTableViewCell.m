//
//  companyContentTableViewCell.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "companyContentTableViewCell.h"
#import "ShareView.h"

@interface companyContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *maintitle;
@property (weak, nonatomic) IBOutlet UILabel *secTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong)ShareView               * shareView;

@end

@implementation companyContentTableViewCell

-(void)setShareModel:(shareModel *)shareModel{
    _shareModel = shareModel;
}
- (IBAction)share:(UIButton *)sender {
    self.shareView.sharetype = @"course";
    self.shareView.shareTitle = _shareModel.title;
    self.shareView.shareDes = _shareModel.context;
    self.shareView.shareURL = _shareModel.url;
    self.shareView.imageUrl = _shareModel.image;
}

-(void)addDataWith:(companyContentModel*)headerModle;{
    if (!headerModle) {
        return;
    }
    self.maintitle.text = headerModle.title;
    self.secTitle.text = headerModle.vice_heading;
}

-(void)ActiveaddDataWith:(companyContentModel*)headerModle;{
    self.maintitle.text = headerModle.title;
    self.secTitle.text = headerModle.add_time;
    self.timeLabel.text = headerModle.vice_heading;
}


+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"companyContentTableViewCell";
    companyContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[companyContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"companyContentTableViewCell" owner:self options:nil]lastObject];
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

- (ShareView *)shareView
{
    if (!_shareView) {
        _shareView  = [[ShareView alloc]init];
        
    }
    return _shareView;
}

@end
