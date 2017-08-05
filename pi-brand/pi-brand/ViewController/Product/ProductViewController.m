//
//  ProductViewController.m
//  HARMAY_PI_BRAND
//
//  Created by shengtian on 2017/7/27.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ProductViewController.h"
#import "XLScrollView.h"
#import "XLSegmentBar.h"
#import "XLConst.h"
#import "UIViewController+XLScroll.h"

#import "Product1TableViewController.h"
#import "Product2TableViewController.h"
#import "Product3TableViewController.h"
#import "SearchViewController.h"

@interface ProductViewController ()<UIScrollViewDelegate,XLSegmentBarDelegate,XLStudyChildVCDelegate,UIGestureRecognizerDelegate>
{
    NSInteger _currentIndex;
}

@property (nonatomic, strong) UIView* titleView;
@property (nonatomic,strong) XLScrollView *contentView;
@property (nonatomic,weak) UIImageView *header;
@property (nonatomic,weak) XLSegmentBar *bar;
@property (nonatomic, strong)UIPageControl* pageControl;
@property (nonatomic, strong) UIImageView* backImageView;

@property (nonatomic, strong)NSMutableArray* backImageArray;

@property(nonatomic ,assign) BOOL zoom;

@end

@implementation ProductViewController

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

-(void)leftPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_product"] forState:normal];
    [rightBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChilds];
    
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.bounds.size.width, 0);
    
    self.header.frame = CGRectMake(0, navBarH, self.view.bounds.size.width, headerImgH);
    
    self.bar.frame = CGRectMake(0, navBarH + headerImgH, self.view.bounds.size.width, barH);
    
    // 选中第0个VC
    [self selectedIndex:2];
    [self selectedIndex:1];
    [self selectedIndex:0];
    _backImageView = [UIImageView new];
    _backImageView.alpha = 0;
    [self.view insertSubview:_backImageView atIndex:0];
    _backImageView.frame = CGRectMake(-(screenHeight*BackImageRate - screenWidth)/2, 0, screenHeight*BackImageRate, screenHeight);
    
    _backImageArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getImageURl:) name:kGetImageURLKey object:nil];
    self.navigationItem.titleView = self.titleView;
    
    UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    [HUDView showHUD:self];
}
- (void)handleSwipeFrom:(UIPanGestureRecognizer *)recognizer{
    CGPoint startLocation;CGPoint stopLocation;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        startLocation = [recognizer translationInView:self.view];
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        stopLocation = [recognizer translationInView:self.view];
        CGFloat dx = stopLocation.x - startLocation.x;
        if(dx>85) {
            if (_currentIndex>0) {
                _currentIndex--;
                [self selectedIndex:_currentIndex];
                self.bar.changeIndex = _currentIndex;
                _pageControl.currentPage = _currentIndex;
            }
        }
        if(dx<-85) {
            if (_currentIndex<2) {
                _currentIndex++;
                [self selectedIndex:_currentIndex];
                self.bar.changeIndex = _currentIndex;
                _pageControl.currentPage = _currentIndex;
            }
        }
        
    }
    
    //    CGFloat dx = stopLocation.x - startLocation.x;
    //
    //    CGFloat dy = stopLocation.y - startLocation.y;
    //
    //    CGFloat distance = sqrt(dx*dx + dy*dy );
    //
    //    NSLog(@"Distance: %f", distance);
}
- (void)search:(UIButton *)btn
{
    [self.navigationController pushViewController:[[SearchViewController alloc]init] animated:NO];
}
- (void)getImageURl:(NSNotification *)not
{
    
    NSString * imageURL = [not.userInfo objectForKey:kGetImageURLKey];
    if (_backImageArray.count<=3) {
        [_backImageArray addObject:imageURL];
    }
    if (imageURL.length>0) {
        UIImageView* newbackImageView = [UIImageView new];
        newbackImageView.alpha = 0;
        [self.view insertSubview:newbackImageView atIndex:0];
        newbackImageView.frame = CGRectMake(-(screenHeight*BackImageRate - screenWidth)/2, 0, screenHeight*BackImageRate, screenHeight);
        [newbackImageView sd_setImageWithURL:[imageURL safeUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView transitionWithView:_backImageView duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _backImageView.alpha = 0;
                newbackImageView.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [_backImageView removeFromSuperview];
                    _backImageView = nil;
                    _backImageView = newbackImageView;
                }
            }];
        }];
    }
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - private
/** 添加子控制器*/
- (void)addChilds {
    [self addChildWithVC:[Product1TableViewController new] title:@"第一"];
    [self addChildWithVC:[Product2TableViewController new] title:@"第二"];
    [self addChildWithVC:[Product3TableViewController new] title:@"第三"];
}
- (void)addChildWithVC:(UITableViewController *)vc title:(NSString *)title {
    vc.title = title;
    [self addChildViewController:vc];
}
/** 选中索引对应VC*/
- (void)selectedIndex:(NSInteger)index {
    UIViewController *VC = self.childViewControllers[index];
    if (!VC.view.superview) {
        VC.view.frame = CGRectMake(index * self.contentView.frame.size.width, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [self.contentView addSubview:VC.view];
    }
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, 0) animated:YES];
    _currentIndex = index;
}

#pragma mark - UIScrollViewDelegate
// 滚动完成调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat offsetX = scrollView.contentOffset.x;
//    NSInteger i = offsetX / scrollView.frame.size.width;
//    [self selectedIndex:i];
//    self.bar.changeIndex = i;
//    _pageControl.currentPage = i;
//    if (_backImageArray.count>i) {
//        [UIView transitionWithView:_backImageView duration:during options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            [_backImageView sd_setImageWithURL:[_backImageArray[i] safeUrlString]];
//            _backImageView.alpha = 1;
//        } completion:nil];
//    }
    
}


#pragma mark - XLSegmentBarDelegate
- (void)segmentBar:(XLSegmentBar *)segmentBar tapIndex:(NSInteger)index {
    [self selectedIndex:index];
}
#pragma mark - XLStudyChildVCDelegate
- (void)childVc:(UIViewController *)childVc scrollViewDidScroll:(UIScrollView *)scroll {
    CGFloat offsetY = scroll.contentOffset.y;
    UIViewController *currentVC = self.childViewControllers[_currentIndex];
    if ([currentVC isEqual:childVc]) {
        CGRect headerFrame = self.header.frame;
        headerFrame.origin.y = navBarH - offsetY;
        // header上滑到导航条位置时，固定
        if (headerFrame.origin.y <= -(headerImgH - navBarH)) {
            headerFrame.origin.y = -(headerImgH - navBarH);
        }
        // header向下滑动时，固定
        else if (headerFrame.origin.y >= navBarH) {
            headerFrame.origin.y = navBarH;
        }
        self.header.frame = headerFrame;
        
        CGRect barFrame = self.bar.frame;
        barFrame.origin.y = CGRectGetMaxY(self.header.frame);
        self.bar.frame = barFrame;
        
        // 改变其他VC中的scroll偏移
        [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isMemberOfClass:[currentVC class]]) {
                [obj setCurrentScrollContentOffsetY:offsetY];
            }
        }];
    }
    CGFloat offset = scroll.contentOffset.y;
    if (offset>=BackZoomHeight) {
        if (!_zoom) {
            [UIView animateWithDuration:0.8 animations:^{
                _backImageView.frame = CGRectMake(-BackZoomWith-(screenHeight*BackImageRate - screenWidth)/2, -BackZoomHeight, screenHeight*BackImageRate + BackZoomWith*2, screenHeight + BackZoomHeight*2);
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

#pragma mark - lazy
- (XLScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[XLScrollView alloc] initWithFrame:CGRectMake(0, navBarH, self.view.bounds.size.width, self.view.bounds.size.height - navBarH)];
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.bouncesZoom = NO;
        _contentView.bounces = NO;
        _contentView.scrollEnabled = NO;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}
- (UIImageView *)header {
    if (!_header) {
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.userInteractionEnabled = YES;
        [self.view addSubview:image];
        _header = image;
        
        _pageControl = [UIPageControl new];
        _pageControl.numberOfPages = self.childViewControllers.count;
        _pageControl.currentPage = 0;
//        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [_pageControl setValue:[UIImage imageNamed:@"11_07SEL"] forKeyPath:@"_currentPageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"11_07"] forKeyPath:@"_pageImage"];
        _pageControl.userInteractionEnabled = NO;
        [_header addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_header);
            make.bottom.mas_equalTo(-5);
        }];
        
    }
    return _header;
}

- (XLSegmentBar *)bar {
    if (!_bar) {
        NSArray *titles = [self.childViewControllers valueForKey:@"title"];
        XLSegmentBar *bar = [[XLSegmentBar alloc]initWithSegmentModels:titles];
        bar.delegate = self;
        bar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bar];
        _bar = bar;
    }
    return _bar;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 127, 16)];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title_product"]];
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


@end
