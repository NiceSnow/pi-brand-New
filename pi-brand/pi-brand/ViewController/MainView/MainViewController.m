//
//  MainViewController.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/25.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "SearchViewController.h"
#import "mainModle.h"
#import "HUDView.h"


@interface MainViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIImageView* backImageView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property(nonatomic,strong) HUDView* HUD;
@end

@implementation MainViewController


-(void)setTitString:(NSString *)titString{
    DebugLog(@"%@",titString);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftBtn setImage:[UIImage imageNamed:@"icon_nav"] forState:normal];
    [leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton* rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_product"] forState:normal];
    [rightBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.titleView = self.titleView;
    
    _backImageView = [UIImageView new];
    [self.view addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(64);
        make.bottom.offset(0);
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.HUD];
    [self.HUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [self getdata];
    // Do any additional setup after loading the view from its nib.
}

-(void)getdata{
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/index" Parameter:nil succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* urlString = [[data objectForKey:@"back_img"] objectForKey:@"bg_img"];
            [_backImageView sd_setImageWithURL:[urlString safeUrlString]];
            [mainModle mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id"};
            }];
            self.dataArray = (NSMutableArray*)[mainModle mj_objectArrayWithKeyValuesArray:[data objectForKey:@"res"]];
            if (self.dataArray.count) {
                [self.tableView reloadData];
                [self.HUD removeFromSuperview];
            }
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell* cell = [MainTableViewCell createCellWithTableView:tableView];
    [cell addDataWithModel:self.dataArray[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            CompanyViewController* joinVC = [[CompanyViewController alloc]init];
            joinVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.section];
            joinVC.leftCount = 2;
            [self.navigationController pushViewController:joinVC animated:YES];
        }
            break;
        case 1:
        {
            ProductViewController* joinVC = [[ProductViewController alloc]init];
            joinVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.section];
            joinVC.leftCount = 2;
            [self.navigationController pushViewController:joinVC animated:YES];
        }
            break;
        case 2:
        {
            JoinusViewController* joinVC = [[JoinusViewController alloc]init];
            joinVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.section];
            joinVC.leftCount = 2;
            [self.navigationController pushViewController:joinVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 5;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}


-(void)search:(UIButton*)btn{
    [self.navigationController pushViewController:[[SearchViewController alloc]init] animated:NO];
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

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 127, 16)];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_logo"]];
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

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, screenHeight*2/7)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

-(HUDView *)HUD{
    if (!_HUD) {
        _HUD = [HUDView new];
        
    }
    return _HUD;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
