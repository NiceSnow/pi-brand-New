//
//  SubCompanyViewController2.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "SubCompanyViewController2.h"
#import "UIViewController+XLScroll.h"
#import "CompanyHeaderTableViewCell.h"
#import "ActiveTableViewCell.h"
#import "ActiveViewController.h"

@interface SubCompanyViewController2 ()

@end

@implementation SubCompanyViewController2

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(void)setHeadModel:(companyHeaderModel *)headModel{
    _headModel = headModel;
}

-(void)setRes:(NSArray<subModel2 *> *)res{
    _res = res;
    [self.tableView reloadData];
    [UIView transitionWithView:self.tableView duration:tableViewDuring options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.tableView.alpha = 1;
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScroll];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 5;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.bounces = NO;
    self.tableView.alpha = 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [UIImageView new];
    UIView* witView = [UIView new];
    witView.backgroundColor = [UIColor whiteColor];
    [view addSubview:witView];
    [witView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    if (_headModel.icon.length>0) {
        imageview.alpha = 0;
        [imageview sd_setImageWithURL:[_headModel.icon safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:imageview duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                imageview.alpha = 1;
            } completion:nil];
        }];
    }
    [witView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        make.width.mas_equalTo(screenWidth*320/750);
        make.height.mas_equalTo((screenWidth*320/750)*35/320);
    }];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.res.count + 1);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    }
    subModel2* modle = self.res[indexPath.row - 1];
    ActiveViewController* ActiveVC = [[ActiveViewController alloc]init];
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/activity_detail" Parameter:@{@"id":modle.ID} succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* urlString = [[data objectForKey:@"back_img"] objectForKey:@"bg_img"];
            ActiveVC.backImageString = urlString;
            ActiveVC.headModle = [companyHeaderModel mj_objectWithKeyValues:[data objectForKey:@"head"]];
            [companyContentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id",
                         @"Description":@"description"
                         };
            }];
            ActiveVC.shareModel = [shareModel mj_objectWithKeyValues:[data objectForKey:@"share"]];
            ActiveVC.contentModel = [companyContentModel mj_objectWithKeyValues:[data objectForKey:@"res"]];
            [self.navigationController pushViewController:ActiveVC animated:YES];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CompanyHeaderTableViewCell* cell = [CompanyHeaderTableViewCell createCellWithTableView:tableView];
        [cell addDataWith:_headModel];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ActiveTableViewCell *cell = [ActiveTableViewCell createCellWithTableView:tableView];
        [cell addDataWith:self.res[indexPath.row - 1]];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

@end
