//
//  Product2TableViewController.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Product2TableViewController.h"
#import "UIViewController+XLScroll.h"
#import "Product2Cell.h"
#import "PickerView.h"
#import "ShareView.h"

@interface Product2TableViewController ()<PickerViewDelegte>
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)PickerView * pickView;
@property (nonatomic, strong)ShareView               * shareView;

@end

@implementation Product2TableViewController

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

-(void)getdata
{
    
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/store_list" Parameter:nil succeed:^(NSURLSessionDataTask *task, id responseObject) {
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

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
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
    [logoImageView sd_setImageWithURL:[_dict[@"head"][@"img"] safeUrlString] placeholderImage:[UIImage imageNamed:@"11"]];
    [backView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.mas_offset(screenWidth*320/750);
        make.height.mas_offset((screenWidth*320/750)*40/320);
    }];
    
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = _dict[@"head"][@"title"];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = UICOLOR_RGB_Alpha(0x000000, 1);
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView);
        make.top.equalTo(logoImageView.mas_bottom).offset(15);
    }];
    _titleLabel = titleLabel;
    
    UIButton * storeButton = [UIButton new];
    [storeButton setBackgroundImage:[UIImage imageNamed:@"1_03"] forState:normal];
    [storeButton addTarget:self action:@selector(storeAction) forControlEvents:UIControlEventTouchUpInside];
    [storeButton setTitle:@"所有店铺" forState:normal];
    [storeButton setTitleColor:UICOLOR_RGB_Alpha(0x000000, 1) forState:normal];
    storeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    storeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backView addSubview:storeButton];
    [storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-35);
    }];
    
    UIButton * dateButton = [UIButton new];
    [dateButton setBackgroundImage:[UIImage imageNamed:@"1_05"] forState:normal];
    [dateButton setBackgroundImage:[UIImage imageNamed:@"1_03"] forState:UIControlStateSelected];
    [dateButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateButton setTitle:@"上新时间" forState:normal];
    [dateButton setTitle:@"上新时间" forState:UIControlStateSelected];
    [dateButton setTitleColor:UICOLOR_RGB_Alpha(0x000000, 1) forState:normal];
    [dateButton setTitleColor:UICOLOR_RGB_Alpha(0x000000, 1) forState:UIControlStateSelected];
    dateButton.titleLabel.font = [UIFont systemFontOfSize:12];
    dateButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backView addSubview:dateButton];
    [dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeButton.mas_right).offset(5);
        make.centerY.equalTo(storeButton);
    }];
    
    
    UIButton * shareButton = [UIButton new];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:normal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(dateButton);
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
    return [_dict[@"res"] count];
}

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
    Product2Cell *cell = [Product2Cell createCellWithTableView:tableView];
    if (_dict) {
        cell.dict = _dict[@"res"][indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)storeAction
{
    self.pickView.dataArray = @[@"第一条",@"第二条",@"第三条"];
}
- (void)dateButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
- (void)shareAction
{
    self.shareView.sharetype = @"course";
    self.shareView.shareTitle = @"title";
    self.shareView.shareDes = @"title";
    self.shareView.shareURL = @"title";
}
- (PickerView *)pickView
{
    if (!_pickView) {
        _pickView = [[PickerView alloc]init];
        _pickView.delegate = self;
    }
    return _pickView;
}
- (void)pickerView:(PickerView *)pickerView index:(NSInteger)index{
    DebugLog(@"%@",@(index));
}
- (ShareView *)shareView
{
    if (!_shareView) {
        _shareView  = [[ShareView alloc]init];
        
    }
    return _shareView;
}
@end

