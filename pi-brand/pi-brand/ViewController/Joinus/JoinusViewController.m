//
//  JoinusViewController.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "JoinusViewController.h"
#import "JoinusViewCellCell.h"
#import "JoinusViewCell.h"
#import "companyHeaderModel.h"
#import "joinMainModel.h"
#import "joinSubModel.h"
#import "SearchViewController.h"

@interface JoinusViewController ()<UITabBarDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView* titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) UIImageView* backImageView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSDictionary * jobDict;
@property(nonatomic,strong) HUDView* HUD;

@end

@implementation JoinusViewController

-(void)setLeftCount:(NSInteger)leftCount{
    UIButton* leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftBtn setImage:[UIImage imageNamed:@"icon_nav"] forState:normal];
    [leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* leftBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    leftBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn2 setImage:[UIImage imageNamed:@"back"] forState:normal];
    [leftBtn2 addTarget:self action:@selector(leftPress) forControlEvents:UIControlEventTouchUpInside];
    
    if (leftCount == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    }else{
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:leftBtn],[[UIBarButtonItem alloc]initWithCustomView:leftBtn2]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_product"] forState:normal];
    [rightBtn addTarget:self action:@selector(search1:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    _backImageView = [UIImageView new];
    [self.view insertSubview:_backImageView atIndex:0];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    _dataArray = [NSMutableArray array];
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, screenWidth, screenHeight/3.0);
    _tableview.tableHeaderView = headerView;
    _tableview.tableFooterView = [UIView new];
    _tableview.estimatedRowHeight = 5;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.titleView = self.titleView;
    [self.view addSubview:self.HUD];
    [self.HUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [self getdata];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset>=35) {
        [UIView animateWithDuration:0.5 animations:^{
            _backImageView.frame = CGRectMake(-80, -80, screenWidth + 160, screenHeight + 160) ;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _backImageView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        }];
    }
}

-(void)getdata{
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/recruit" Parameter:nil succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* urlString = [[data objectForKey:@"back_img"] objectForKey:@"bg_img"];
            [_backImageView sd_setImageWithURL:[urlString safeUrlString]];
            [joinMainModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id"};
            }];
            companyHeaderModel* model = [companyHeaderModel mj_objectWithKeyValues:[data objectForKey:@"head"]];
            
            joinMainModel* mainModel = [joinMainModel mj_objectWithKeyValues:[data objectForKey:@"main"]];
            [_dataArray addObject:@[model,mainModel]];
            NSArray* sub = [joinSubModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"sub"]];
            [_dataArray addObject:sub];
            
            joinSubModel * model1 = _dataArray[1][0];
            [self getmessageWithJobID:model1.m_id];
            [_tableview reloadData];
            [self.HUD removeFromSuperview];
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
}

-(void)getmessageWithJobID:(NSString *)jobID
{
//    招聘职位信息  下面加载webview
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/recruit_type" Parameter:@{@"id":jobID} succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            
            _jobDict = [responseObject objectForKey:@"data"];
            [self.tableview reloadData];
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
}

-(void)leftPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)search1:(UIButton *)btn
{
    [self.navigationController pushViewController:[[SearchViewController alloc]init] animated:NO];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0) {
        JoinusViewCellCell * cell = [JoinusViewCellCell createCellWithTableView:tableView];
        if (_dataArray.count) {
            cell.dataArray = _dataArray[indexPath.row];
        }
        return cell;
    }else{
        JoinusViewCell * cell = [JoinusViewCell createCellWithTableView:tableView];
        if (_jobDict    ) {
            cell.dict = _jobDict;
        }
        __weak typeof(self)weakSelf = self;
        cell.block = ^(NSInteger index) {
            joinSubModel *model = weakSelf.dataArray[1][index];
            [weakSelf getmessageWithJobID:model.m_id];
        };
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 127, 16)];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title_recruitment"]];
        [_titleView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_titleView);
            make.height.equalTo(@16);
            make.width.equalTo(@127);
        }];
        
        _titleView.alpha = 0;
    }
    return _titleView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(HUDView *)HUD{
    if (!_HUD) {
        _HUD = [HUDView new];
        
    }
    return _HUD;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.0001;
//}

@end
