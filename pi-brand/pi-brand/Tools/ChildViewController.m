//
//  ChildViewController.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/26.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ChildViewController.h"


@implementation ChildViewController
+ (ChildViewController *)instance
{
    static  ChildViewController*instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(BaseNavigationController *)MainNavgation{
    if (!_MainNavgation) {
        _MainNavgation = [[BaseNavigationController alloc]initWithRootViewController:self.MainVC];
    }
    return _MainNavgation;
}

-(MainViewController *)MainVC{
    if (!_MainVC) {
        _MainVC = [[MainViewController alloc]init];
    }
    return _MainVC;
}

-(BaseNavigationController *)WebNavgation{
    if (!_WebNavgation) {
        _WebNavgation = [[BaseNavigationController alloc]initWithRootViewController:self.webVC];
    }
    return _WebNavgation;
}

-(WebViewController *)webVC{
    if (!_webVC) {
        _webVC = [[WebViewController alloc]init];
    }
    return _webVC;
}

-(BaseNavigationController *)joinNavgation{
    if (!_joinNavgation) {
        _joinNavgation = [[BaseNavigationController alloc]initWithRootViewController:self.joinVC];
    }
    return _joinNavgation;
}

-(JoinusViewController *)joinVC{
    if (!_joinVC) {
        _joinVC = [[JoinusViewController alloc]init];
    }
    return _joinVC;
}

-(BaseNavigationController *)companyNavgation{
    if (!_companyNavgation) {
        _companyNavgation = [[BaseNavigationController alloc]initWithRootViewController:self.companyVC];
    }
    return _companyNavgation;
}

-(CompanyViewController *)companyVC{
    if (!_companyVC) {
        _companyVC = [[CompanyViewController alloc]init];
    }
    return _companyVC;
}

-(BaseNavigationController *)productNavgation{
    if (!_productNavgation) {
        _productNavgation = [[BaseNavigationController alloc]initWithRootViewController:self.productVC];
    }
    return _productNavgation;
}

-(ProductViewController *)productVC{
    if (!_productVC) {
        _productVC = [[ProductViewController alloc]init];
    }
    return _productVC;
}

-(BaseNavigationController *)shopNavgation{
    if (!_shopNavgation) {
        _shopNavgation = [[BaseNavigationController alloc]initWithRootViewController:self.shopVC];
    }
    return _shopNavgation;
}

-(shopViewController *)shopVC{
    if (!_shopVC) {
        _shopVC = [[shopViewController alloc]init];
    }
    return _shopVC;
}

@end
