//
//  Product3TableViewController.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Product3TableViewController.h"
#import "UIViewController+XLScroll.h"
#import "Product3Cell.h"

@interface Product3TableViewController ()
@property (nonatomic, strong)NSDictionary * dict;
@end

@implementation Product3TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScroll];
    self.tableView.separatorStyle = 0;
    self.tableView.estimatedSectionHeaderHeight = 5;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 5;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self getdata];
}
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
-(void)getdata
{
    
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/product_line" Parameter:nil succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* urlString = [[data objectForKey:@"back_img"] objectForKey:@"bg_img"];
            [[NSNotificationCenter defaultCenter]postNotificationName:kGetImageURLKey object:nil userInfo:@{kGetImageURLKey:urlString}];
            
            _dict = data;
            [self.tableView reloadData];
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * logoImageView = [[UIImageView alloc]init];
    [logoImageView sd_setImageWithURL:[_dict[@"head"][@"icon"] safeUrlString] placeholderImage:[UIImage imageNamed:@"11"]];

    [backView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.mas_offset(screenWidth*320/750);
        make.height.mas_offset((screenWidth*320/750)*40/320);
    }];
    
    UIImageView * backImageView = [[UIImageView alloc]init];
    [backImageView sd_setImageWithURL:[_dict[@"head"][@"image"] safeUrlString] placeholderImage:[UIImage imageNamed:@"03"]];

    [backView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(logoImageView.mas_bottom).offset(25);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(screenWidth*380/750);
//        make.height.mas_equalTo((screenWidth*380/750)*165/380);
    }];
    

    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [_dict[@"res"] count];}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section<[_dict[@"pro"] count]-1) {
//        return 0.01;
//    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Product3Cell *cell = [Product3Cell createCellWithTableView:tableView];
    cell.dict = _dict[@"res"][indexPath.row];
    return cell;
}



@end
