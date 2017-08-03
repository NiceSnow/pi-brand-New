//
//  HotTableViewCell.m
//  pi-brand
//
//  Created by Madodg on 2017/8/4.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"HotTableViewCell";
    HotTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[HotTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"HotTableViewCell" owner:self options:nil]lastObject];
        
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
