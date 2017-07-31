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

@interface ProductViewController ()<UIScrollViewDelegate,XLSegmentBarDelegate,XLStudyChildVCDelegate>
{
    NSInteger _currentIndex;
}
@property(nonatomic,strong) HUDView* HUD;
@property (nonatomic, strong) UIView* titleView;
@property (nonatomic,strong) XLScrollView *contentView;
@property (nonatomic,weak) UIImageView *header;
@property (nonatomic,weak) XLSegmentBar *bar;
@property (nonatomic, strong)UIPageControl* pageControl;
@property (nonatomic, strong) UIImageView* backImageView;

@property (nonatomic, strong)NSMutableArray* backImageArray;

@end

@implementation ProductViewController

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
    [self selectedIndex:0];
    _backImageView = [UIImageView new];
    [self.view insertSubview:_backImageView atIndex:0];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    _backImageArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getImageURl:) name:kGetImageURLKey object:nil];
    self.navigationItem.titleView = self.titleView;
    [self.view addSubview:self.HUD];
    [self.HUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}
- (void)search:(UIButton *)btn
{
    [self.navigationController pushViewController:[[SearchViewController alloc]init] animated:NO];
}
- (void)getImageURl:(NSNotification *)not
{
    [self.HUD removeFromSuperview];
    NSString * imageURL = [not.userInfo objectForKey:kGetImageURLKey];
    if (_backImageArray.count<=3) {
        [_backImageArray addObject:imageURL];
    }
    [_backImageView sd_setImageWithURL:[imageURL safeUrlString]];
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
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, 0) animated:NO];
    _currentIndex = index;
}

#pragma mark - UIScrollViewDelegate
// 滚动完成调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger i = offsetX / scrollView.frame.size.width;
    [self selectedIndex:i];
    self.bar.changeIndex = i;
    _pageControl.currentPage = i;
    if (_backImageArray.count>i) {
        [_backImageView sd_setImageWithURL:[_backImageArray[i] safeUrlString]];
    }
    
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

#pragma mark - lazy
- (XLScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[XLScrollView alloc] initWithFrame:CGRectMake(0, navBarH, self.view.bounds.size.width, self.view.bounds.size.height - navBarH)];
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
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

-(HUDView *)HUD{
    if (!_HUD) {
        _HUD = [HUDView new];
        
    }
    return _HUD;
}

@end
