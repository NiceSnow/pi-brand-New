//
//  HotTableViewCell.m
//  pi-brand
//
//  Created by Madodg on 2017/8/4.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "HotTableViewCell.h"
#import "SearchViewController.h"

@implementation HotTableViewCell{
    NSArray* modleArray;
}
- (IBAction)btnPress:(UIButton *)sender {
    SearchViewController* VC = (SearchViewController*)[self ViewController];
    [VC searchPress:sender];
}

-(void)addDataWithArray:(NSMutableArray*)arr;{
    modleArray = arr;
    if (arr.count<=0) {
        return;
    }
    for (int i = 0; i < arr.count; i++) {
        NSString* string = arr[i];
        UIButton* btn = [self.contentView viewWithTag:1000+i];
        btn.layer.cornerRadius = 13.0;
        btn.layer.borderColor = UICOLOR_RGB_Alpha(0x535353, 1).CGColor;
        btn.layer.borderWidth = 0.5;
        if (string.length>0) {
            [btn setTitle:[NSString stringWithFormat:@"    %@    ",string] forState:normal];
        }
    }
}

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
