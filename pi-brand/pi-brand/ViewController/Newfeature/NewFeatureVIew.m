//
//  XL_NewFeatureVIew.m
//  新浪微博
//
//  Created by mdd on 14-7-20.
//  Copyright (c) 2014年 mdd. All rights reserved.
//

#import "NewFeatureVIew.h"
#import "BaseNavigationController.h"

static NSInteger kCount = 3;
@interface NewFeatureVIew () <UIScrollViewDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;
    NSArray* dataArray;
    UIButton* _lastBtn;
    CGFloat width;
    CGFloat height;
    BOOL haveNet;
    
}
@end

@implementation NewFeatureVIew

#pragma mark 自定义view
- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage fullscrennImage:@"new_feature_background.png"];
    /*
     以3.5inch为例（320x480）
     1> 当没有状态栏，applicationFrame的值{{0, 0}, {320, 480}}
     2> 当有状态栏，applicationFrame的值{{0, 20}, {320, 460}}
     */
    imageView.frame = [UIScreen mainScreen].applicationFrame;
    // 跟用户进行交互（这样才可以接收触摸事件）
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/guide_list" Parameter:nil succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            dataArray = [responseObject objectForKey:@"data"];
            kCount = dataArray.count;
            width = [[responseObject objectForKey:@"width"] floatValue];
            height = [[responseObject objectForKey:@"height"] floatValue];;
            [self addScrollView];
            
            [self addScrollImages];
            
            [self addPageControl];
            haveNet = YES;
        }else{
            haveNet = NO;
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        haveNet = NO;
    } netWork:^(BOOL netWork) {
        
    }];
    
}

- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    CGRect rect = [[UIScreen mainScreen] bounds];
    scroll.frame = rect;
    scroll.showsHorizontalScrollIndicator = NO;
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0);
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

- (void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    
    for (int i = 0; i<kCount; i++) {
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(i * size.width, 0, size.width, size.height )];
        [_scroll addSubview:backView];
        UIImageView * backImageView = [UIImageView new];
        [backView addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
            make.width.mas_equalTo(screenHeight*width/height);
            make.height.mas_equalTo(screenHeight);
        }];
        [backImageView sd_setImageWithURL:[[dataArray[i] objectForKey:@"img"] safeUrlString]placeholderImage:nil];
        backImageView.userInteractionEnabled = YES;
        [_scroll addSubview:backView];
    }
}

#pragma mark 添加分页指示器
- (void)addPageControl
{
    UIPageControl *page = [[UIPageControl alloc] init];
    page.backgroundColor = [UIColor blueColor];
    page.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.93);
    page.numberOfPages = kCount;
    [page setValue:[UIImage imageNamed:@"page"] forKeyPath:@"pageImage"];
    [page setValue:[UIImage imageNamed:@"pageSel"] forKeyPath:@"currentPageImage"];
    [page setSelected:YES];
    [self.view addSubview:page];
    _page = page;
    
    CGRect rect = CGRectMake(screenWidth/3, self.view.bounds.size.height*0.93 - screenWidth/3/4.5, screenWidth/3, screenWidth/3/4.5);
    UIButton * but=[[UIButton alloc]initWithFrame:rect];
    but.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.93);
    but.layer.cornerRadius = 5.0;
    but.layer.borderColor = [UIColor whiteColor].CGColor;
    but.layer.borderWidth = 0.5;
    but.backgroundColor = [UIColor blackColor];
    [but setTitle:@"立即体验" forState:UIControlStateNormal];
    but.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [but setTitleColor:UICOLOR_RGB_Alpha(0xffffff, 1) forState:UIControlStateNormal];
    [but setBackgroundImage:nil forState:UIControlStateNormal];
    [but addTarget:self action:@selector(pressBut:) forControlEvents:UIControlEventTouchUpInside];
    but.hidden = YES;
    but.tag=1226;
    [self.view addSubview:but];
    _lastBtn = but;
}

-(void)pressBut:(id)sender
{
    if (haveNet) {
        [UIApplication sharedApplication].keyWindow.rootViewController = self.sideMenuViewController;
        [UserDefault setObject:newVersion forKey:versionKey];
        [UserDefault synchronize];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到设置里面检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

#pragma mark - 滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (_page.currentPage == kCount-1) {
        _page.hidden = YES;
        _lastBtn.hidden = NO;
    }else{
        _page.hidden = NO;
        _lastBtn.hidden = YES;
    }
}

@end
