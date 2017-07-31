//
//  Product1TableViewController.m
//  HARMAY_PI_BRAND
//
//  Created by 刘厚宽 on 2017/7/28.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "Product1TableViewController.h"
#import "UIViewController+XLScroll.h"
#import "Product1Cell.h"
#import <MapKit/MapKit.h>
#import "ShareView.h"

@interface Product1TableViewController ()
{
    UIButton *tempButton;
}
@property (nonatomic, strong)NSMutableArray * titleArray;
@property (nonatomic, strong)NSMutableArray * imageArray;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * subTitleLabel;
@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)UILabel* locationLabel;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)ShareView               * shareView;

@end

@implementation Product1TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScroll];
   
    self.tableView.backgroundColor = [UIColor clearColor];
    _imageArray = [@[@"19_base1",@"23_base1",@"27_base1"] mutableCopy];
    _titleArray = [@[@"上海安福路308号",@"店铺电话：13661138037",@"营业时间10：00-22：00"] mutableCopy];

    self.tableView.separatorStyle = 0;
    self.tableView.estimatedSectionHeaderHeight = 5;
    [self getdataWithCityID:10000];
}


-(void)getdataWithCityID:(NSInteger)cid
{
    NSDictionary * parameter = nil;
    if (cid != 10000) {
        parameter = @{@"city_id":@(cid)};
    }
    
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/product_city" Parameter:parameter succeed:^(NSURLSessionDataTask *task, id responseObject) {
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
    return [_dict[@"pro"] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    
    NSArray * proArray = [NSArray array];
    NSMutableArray * cityArray = [NSMutableArray array];
    if (_dict) {
        proArray = _dict[@"pro"];
        cityArray = [_dict[@"city"] mutableCopy];
        NSDictionary * tempDic = @{@"id":@"10000",@"city_name":@"全部"};
        [cityArray insertObject:tempDic atIndex:0];
    }
    
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[proArray[section][@"img"] safeUrlString] placeholderImage:[UIImage imageNamed:@"15"]];
    [backView addSubview:imageView];
    _backImageView = imageView;
    
    
    if (section == 0) {
        UIImageView * logoImageView = [[UIImageView alloc]init];
        [logoImageView sd_setImageWithURL:[_dict[@"head"][@"icon"] safeUrlString]];
        [backView addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.offset(20);
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
        
        
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textColor  = UICOLOR_RGB_Alpha(0x000000, 1);
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.text = @"实体店体验馆";
        [backView addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(_titleLabel.mas_bottom).offset(35);
        }];
        
        
        UIButton * shareButton = [UIButton new];
        [shareButton setImage:[UIImage imageNamed:@"share"] forState:normal];
        [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(_subTitleLabel);
        }];
        
        [backView layoutIfNeeded];
        UIButton * lastBtn = [UIButton new];
        for (NSInteger i = 0; i<cityArray.count; i++) {
            
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            
            UIButton * btn = [UIButton new];
            btn.tag =  [cityArray[i][@"id"] integerValue]+100;
            [btn addTarget:self action:@selector(changeCityAction:) forControlEvents:UIControlEventTouchUpInside];
    
            [btn setBackgroundImage:[UIImage imageNamed:@"4"] forState:normal];
            [btn setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateSelected];
            [btn setTitle:cityArray[i][@"city_name"] forState:normal];
            [btn setTitle:cityArray[i][@"city_name"] forState:UIControlStateSelected];
            [btn setTitleColor:UICOLOR_RGB_Alpha(0x6b6a6a, 1) forState:normal];
            [btn setTitleColor:UICOLOR_RGB_Alpha(0x6b6a6a, 1) forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            CGFloat Width_Space   =  10.0f;
            CGFloat Height_Space  =  10.0f;
            CGFloat x = 15;
            CGFloat y = CGRectGetMaxY(_subTitleLabel.frame)+35;
            CGFloat width = (screenWidth-20-Width_Space*2-2*x)/3.0;
            CGFloat height = 30.0;
            btn.frame = CGRectMake(index * (width + Width_Space) + x, page  * (height + Height_Space)+y, width, height);
            [backView addSubview:btn];
            lastBtn = btn;
        }
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth-50);
            make.height.mas_equalTo((screenWidth-50)*429/632);
            make.centerX.equalTo(backView);
            make.top.equalTo(lastBtn.mas_bottom).offset(15);
        }];
        
    }else{
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth-50);
            make.height.mas_equalTo((screenWidth-50)*429/632);
            make.centerX.equalTo(backView);
            make.top.mas_equalTo(15);
        }];
    }
    
    
    UILabel * label = [UILabel new];
    label.text = proArray[section][@"city_name"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UICOLOR_RGB_Alpha(0xe52c4e, 1);
    [backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(imageView.mas_bottom).offset(15);
    }];
    _locationLabel = label;
    
    UILabel * nameLabel = [UILabel new];
    nameLabel.text = proArray[section][@"summary"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = UICOLOR_RGB_Alpha(0x313131, 1);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:nameLabel.text];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor blackColor]
     
                          range:NSMakeRange(nameLabel.text.length-6, 6)];
    nameLabel.attributedText = AttributedStr;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(label.mas_bottom).offset(6);
        make.bottom.mas_equalTo(-30);
    }];
    _nameLabel = nameLabel;
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section<[_dict[@"pro"] count]-1) {
        return 0.01;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Product1Cell *cell = [Product1Cell createCellWithTableView:tableView];
    if (_dict) {
        NSString * content = nil;
        if (indexPath.row == 0) {
            content = _dict[@"pro"][indexPath.section][@"address"];
        }else if (indexPath.row == 1){
            content = [NSString stringWithFormat:@"商铺电话：%@",_dict[@"pro"][indexPath.section][@"tel"]];
        }else if (indexPath.row == 2){
            content = [NSString stringWithFormat:@"营业时间：%@",_dict[@"pro"][indexPath.section][@"business_hours"]];
        }
        cell.contentString = content;
        
    }
    cell.imageString = self.imageArray[indexPath.row];
    if (indexPath.section == [_dict[@"pro"] count]-1) {
        if (indexPath.row == 2) {
            cell.lineView.hidden = YES;
        }else{
            cell.lineView.hidden = NO;
            
        }
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([_dict[@"pro"][indexPath.section][@"latitude"] floatValue], [_dict[@"pro"][indexPath.section][@"longitude"] floatValue]);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
    }else if(indexPath.row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_dict[@"pro"][indexPath.section][@"tel"]]]];
    }else if (indexPath.row ==2){
        
    }
    
    
}
- (void)shareAction
{
    self.shareView.sharetype = @"course";
    self.shareView.shareTitle = @"title";
    self.shareView.shareDes = @"title";
    self.shareView.shareURL = @"title";
}
- (void)changeCityAction:(UIButton *)btn
{
//    btn.selected = !btn.selected;
    tempButton.selected = NO;
    btn.selected = YES;
    tempButton = btn;
    [self getdataWithCityID:btn.tag-100];
}

- (ShareView *)shareView
{
    if (!_shareView) {
        _shareView  = [[ShareView alloc]init];
        
    }
    return _shareView;
}
@end
