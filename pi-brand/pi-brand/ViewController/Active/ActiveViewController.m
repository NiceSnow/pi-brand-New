//
//  ActiveViewController.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/29.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ActiveViewController.h"


#import "CompanyHeaderTableViewCell.h"
#import "companyContentTableViewCell.h"
#import "SearchViewController.h"


@interface ActiveViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIImageView* backImageView;
@property(nonatomic,strong)   UIWebView* webView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIView* titleView;
@property(nonatomic,assign) BOOL zoom;

@end

@implementation ActiveViewController

-(void)search{
    [self.navigationController pushViewController:[[SearchViewController alloc]init] animated:NO];
}

-(void)setID:(NSString *)ID{
    _ID = ID;
}

-(void)setBackImageString:(NSString *)backImageString{
    _backImageString = backImageString;
}

-(void)setHeadModle:(companyHeaderModel *)headModle{
    _headModle = headModle;
}

-(void)setContentModel:(companyContentModel *)contentModel{
    _contentModel = contentModel;
}

-(void)setShareModel:(shareModel *)shareModel{
    _shareModel = shareModel;
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
    _backImageView.alpha = 0;
    [self.view addSubview:_backImageView];
    

    _backImageView.frame = CGRectMake(-(screenHeight*BackImageRate - screenWidth)/2, 0, screenHeight*BackImageRate, screenHeight);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(64);
        make.bottom.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [HUDView showHUD:self];
    [self.webView loadHTMLString:_contentModel.Description baseURL:nil];
    
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
    [HUDView hiddenHUD];
    self.tableView.alpha = 0;
    [self.tableView reloadData];
    if (_backImageString.length>0) {
        [_backImageView sd_setImageWithURL:[_backImageString safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:_backImageView duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _backImageView.alpha = 1;
            } completion:nil];
        }];
    }
    [UIView transitionWithView:self.tableView duration:tableViewDuring options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.tableView.alpha = 1;
    } completion:nil];
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
        _tableView.alpha = 0;
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
