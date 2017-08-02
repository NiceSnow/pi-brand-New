//
//  MenuTableViewCell2.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/26.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "MenuTableViewCell2.h"
#import "linkModel.h"
#import <UIKit/UIKit.h>

@interface MenuTableViewCell2 (){
    UIButton* lastBtn;
    NSArray* modleArray;
}

@end


@implementation MenuTableViewCell2

-(void)addDataWithArray:(NSArray*)arr;{
    modleArray = arr;
    if (arr.count<=0) {
        return;
    }
    for (int i = 0; i < arr.count; i++) {
        linkModel* modle = arr[i];
        UIButton* btn = [self.contentView viewWithTag:1000+i];
        if (modle.img.length>0) {
            [btn sd_setImageWithURL:[modle.img safeUrlString] forState:normal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGSize size = image.size;
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(size.width/2);
                    make.height.mas_equalTo(size.height/2);
                }];
            }];
        }
    }
}

-(void)btnPress:(UIButton*)btn{
    DebugLog(@"%ld",btn.tag);
}

- (IBAction)jumpToWebView:(UIButton *)sender {
    DebugLog(@"%ld",sender.tag);
    WebViewController* VC = [ChildViewController instance].webVC;
    NSInteger index = sender.tag - 1000;
    linkModel* modle = modleArray[index];
    VC.MYURL = [modle.url safeUrlString];
    VC.LeftCount = 1;
    [self.ViewController.sideMenuViewController setContentViewController:[ChildViewController instance].WebNavgation animated:YES];
    [self.ViewController.sideMenuViewController hideMenuViewController];
}

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"MenuTableViewCell2";
    MenuTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[MenuTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MenuTableViewCell2" owner:self options:nil]lastObject];
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
