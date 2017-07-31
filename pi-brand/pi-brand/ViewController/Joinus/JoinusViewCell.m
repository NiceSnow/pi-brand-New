//
//  JoinusViewCell.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "JoinusViewCell.h"
#import "joinSubModel.h"

@interface JoinusViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTypelabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end
@implementation JoinusViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString * iden = @"JoinusViewCell";
    JoinusViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[JoinusViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JoinusViewCell" owner:self options:nil]lastObject];
    }
    return self;
}
- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[dict[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [_contentLabel setAttributedText:attrStr];
    _workTypelabel.text = dict[@"title"]; 
}
- (IBAction)btn1:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag-1000);
    }
}
- (IBAction)calButton:(UIButton *)sender {
    
    
}
@end
