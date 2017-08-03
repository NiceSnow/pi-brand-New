//
//  ActiveViewController.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/29.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ActiveViewController.h"
#import "companyHeaderModel.h"
#import "companyContentModel.h"

#import "CompanyHeaderTableViewCell.h"
#import "companyContentTableViewCell.h"
#import "SearchViewController.h"


@interface ActiveViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong) companyHeaderModel* headModle;
@property(nonatomic,strong)   companyContentModel* contentModel;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIImageView* backImageView;
@property(nonatomic,strong)   UIWebView* webView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIView* headerView;
@property(nonatomic,strong) HUDView* HUD;
@property (nonatomic, strong) UIView* titleView;
@property(nonatomic,strong) shareModel* shareModel;
@property(nonatomic,assign) BOOL zoom;

@end

@implementation ActiveViewController

-(void)search{
    [self.navigationController pushViewController:[[SearchViewController alloc]init] animated:NO];
}

-(void)setID:(NSString *)ID{
    _ID = ID;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset>=BackZoomHeight) {
        if (!_zoom) {
            [UIView animateWithDuration:0.8 animations:^{
                _backImageView.frame = CGRectMake(-BackZoomRate/2-(screenHeight*BackImageRate - screenWidth)/2, -BackZoomRate/2-(screenHeight*BackImageRate - screenWidth)/2, screenHeight*BackImageRate + BackZoomRate, screenHeight + BackZoomRate) ;
            }];
            _zoom = YES;
        }
    }else{
        if (_zoom) {
            [UIView animateWithDuration:0.8 animations:^{
                _backImageView.frame = CGRectMake(-(screenHeight*BackImageRate - screenWidth)/2, -(screenHeight*BackImageRate - screenWidth)/2, screenHeight*BackImageRate, screenHeight);
                
            }];
            _zoom = NO;
        }
    }
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleView;
    UIButton* leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftBtn setImage:[UIImage imageNamed:@"icon_nav"] forState:normal];
    [leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* leftBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    leftBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn2 setImage:[UIImage imageNamed:@"back"] forState:normal];
    [leftBtn2 addTarget:self action:@selector(leftPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:leftBtn],[[UIBarButtonItem alloc]initWithCustomView:leftBtn2]];
    
    _backImageView = [UIImageView new];
    [self.view addSubview:_backImageView];
    _backImageView.frame = CGRectMake(-(screenHeight*BackImageRate - screenWidth)/2, -(screenHeight*BackImageRate - screenWidth)/2, screenHeight*BackImageRate, screenHeight);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(64);
        make.bottom.offset(0);
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.HUD];
    [self.HUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/activity_detail" Parameter:@{@"id":_ID} succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* urlString = [[data objectForKey:@"back_img"] objectForKey:@"bg_img"];
            if (urlString.length>0) {
                [_backImageView sd_setImageWithURL:[urlString safeUrlString]];
            }
            _headModle = [companyHeaderModel mj_objectWithKeyValues:[data objectForKey:@"head"]];
            [companyContentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id",
                         @"Description":@"description"
                         };
            }];
            self.shareModel = [shareModel mj_objectWithKeyValues:[data objectForKey:@"share"]];
            _contentModel = [companyContentModel mj_objectWithKeyValues:[data objectForKey:@"res"]];
            [self.tableView reloadData];
            [self.webView loadHTMLString:_contentModel.Description baseURL:nil];
            [self.HUD removeFromSuperview];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)leftPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_headModle.icon.length>0&&_headModle.title.length>0&&_headModle.hid>0&&_headModle.image.length>0 &&_contentModel) {
        return 2;
    }else if(_contentModel)
        return 1;
    else
        return 0;
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
    if (_headModle.icon.length>0) {
        [imageview sd_setImageWithURL:[_headModle.icon safeUrlString] placeholderImage:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_headModle.icon.length>0&&_headModle.title.length>0&&_headModle.hid>0&&_headModle.image.length>0) {
        if (indexPath.row == 0) {
            CompanyHeaderTableViewCell* cell = [CompanyHeaderTableViewCell createCellWithTableView:tableView];
            [cell addDataWith:_headModle];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    companyContentTableViewCell* cell = [companyContentTableViewCell createCellWithTableView:tableView];
    cell.shareModel = self.shareModel;
    [cell ActiveaddDataWith:self.contentModel];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(18, 0, screenWidth-36, 1)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}

-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor clearColor];
        UIView* view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-1);
            make.left.offset(10);
            make.bottom.right.offset(-10);
        }];
        [_footerView addSubview:self.webView];
    }
    return _footerView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    self.webView.frame = CGRectMake(18, -1, screenWidth - 36, documentHeight);
    self.footerView.frame = CGRectMake(0, 0, screenWidth, documentHeight + 10);
    self.tableView.tableFooterView = self.footerView;
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

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, screenHeight*2/7)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(HUDView *)HUD{
    if (!_HUD) {
        _HUD = [HUDView new];
        
    }
    return _HUD;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
