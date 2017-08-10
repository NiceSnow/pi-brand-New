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
@property(nonatomic ,assign) BOOL zoom;
@property(nonatomic ,assign)BOOL first;

@end

@implementation JoinusViewController

-(void)setTitString:(NSString *)titString{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

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
    _backImageView.frame = CGRectMake(-(screenHeight*BackImageRate - screenWidth)/2, 0, screenHeight*BackImageRate, screenHeight);
    _dataArray = [NSMutableArray array];
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, screenWidth, screenHeight/3.0);
    _tableview.tableHeaderView = headerView;
    _tableview.tableFooterView = [UIView new];
    _tableview.estimatedRowHeight = 5;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.bounces = NO;
    _tableview.alpha = 0;
    self.navigationItem.titleView = self.titleView;
    [HUDView showHUD:self];
    [self getdata];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset>=BackZoomHeight) {
        if (!_zoom) {
            [UIView animateWithDuration:0.8 animations:^{
                _backImageView.frame = CGRectMake(-BackZoomWith-(screenHeight*BackImageRate - screenWidth)/2, -BackZoomHeight, screenHeight*BackImageRate + BackZoomWith*2, screenHeight + BackZoomHeight*2) ;
            }];
            _zoom = YES;
        }
    }else{
        if (_zoom) {
            [UIView animateWithDuration:0.8 animations:^{
                _backImageView.frame = CGRectMake(-(screenHeight*BackImageRate - screenWidth)/2, 0, screenHeight*BackImageRate, screenHeight);
                
            }];
            _zoom = NO;
        }
    }
}

-(void)getdata{
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/recruit" Parameter:nil succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* urlString = [[data objectForKey:@"back_img"] objectForKey:@"bg_img"];
            
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
            [HUDView hiddenHUD];
            if (urlString.length>0) {
                
                [_backImageView sd_setImageWithURL:[urlString safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [UIView transitionWithView:_backImageView duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        _backImageView.alpha = 1;
                    } completion:nil];
                }];
            }
            [UIView transitionWithView:self.tableview duration:tableViewDuring options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.tableview.alpha = 1;
            } completion:nil];
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
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            if (_first) {
                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]  atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            _first = YES;
            
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


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.0001;
//}

@end
