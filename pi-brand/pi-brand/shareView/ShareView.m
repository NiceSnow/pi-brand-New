//
//  ShareView.m
//  YLHospital_2.0
//
//  Created by AMed on 15/11/30.
//  Copyright © 2015年 博睿精实. All rights reserved.
//

#import "ShareView.h"
//#import "UMSocial.h"

@interface ShareView ()//<UMSocialUIDelegate>



@property (nonatomic, strong)UIControl * overlayView;
@property (nonatomic, strong)UILabel   * shareLabel;
@property (nonatomic, strong)UIButton  * cancleButton;


@end
@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidUI];
    }
    return self;
}


- (void)bulidUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight * .25);
    NSArray * titleArray = @[@"朋友圈",@"好友"];
    NSArray * imageArray = @[@"WeChatFirend",@"WeChat"];
    
    for (NSInteger i = 0; i <titleArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10101+i;
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        UILabel * label = [[UILabel alloc]init];
        label.tag = i+100000;
        label.backgroundColor = [UIColor clearColor];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = kBlackColor;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
    }
    [self addSubview:self.shareLabel];
    [self addSubview:self.cancleButton];
    [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    
    [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i < 3; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:i+10101];
        button.frame = CGRectMake(((CGRectGetWidth(self.frame)/3)*i)+(CGRectGetWidth(self.frame)/3)/2-30, 45, 60, 60);
        UILabel * label = (UILabel *)[self viewWithTag:i+100000];
        label.frame = CGRectMake(CGRectGetWidth(self.frame)/3*i, CGRectGetMaxY(button.frame), CGRectGetWidth(self.frame)/3, 20);
    }

}
- (void)setShareDes:(NSString *)shareDes
{
    _shareDes = shareDes;
    if (shareDes.length >256) {
        _shareDes = [shareDes substringToIndex:256];
    }
}
- (void)setShareURL:(NSString *)shareURL
{
    _shareURL = shareURL;
    [self showShareView];
}
- (UILabel *)shareLabel
{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc]init];
        _shareLabel.text = @"分享到";
//        _shareLabel.textColor = kBlackColor;
        _shareLabel.font = [UIFont systemFontOfSize:13];
    }
    return _shareLabel;
}
- (UIButton *)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancleButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancleButton addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
- (UIControl *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:screenBounds];
        _overlayView.backgroundColor = [UIColor blackColor];
        [_overlayView setAlpha:0.5f];
        [_overlayView addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayView;
}

- (void)btnAction:(UIButton *)btn
{
//    NSInteger tag = btn.tag -10101;
//    
//    if (tag == 0){
//        [self shareWithType:UMShareToWechatTimeline];
//    }else if (tag == 1) {
//        [self shareWithType:UMShareToWechatSession];
//    }else if (tag == 2){
//        [self shareWithType:UMShareToQQ ];
//        
//    }
    
    [self dismissShareView];
}

- (void)shareWithType:(NSString *)type
{
    if (self.sharetype) {
        [self shareScore];
    }
    //分享到微信好友
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareURL;
//    //分享到微信朋友圈
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"%@\n%@",self.shareTitle,self.shareDes];
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareURL;
//    //分享到qq好友
//    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
//    [UMSocialData defaultData].extConfig.qqData.url   = self.shareURL;
//    //取消友盟提示
//    [UMSocialConfig setFinishToastIsHidden:YES position:(UMSocialiToastPositionCenter) ];
//    
//    if (self.shareLogoUrl.length>0) {
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:self.shareDes image:nil location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:self.shareLogoUrl] presentedController:nil completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
////                [ToolsHelper showSuccessMessage:@"分享成功！"];
//            }else if(response.responseCode == UMSResponseCodeCancel){
////                [ToolsHelper showInfoMessage:@"取消分享"];
//            }
//        }];
//    }else{
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:self.shareDes image:[UIImage imageNamed:@"Icon1"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
////                [ToolsHelper showSuccessMessage:@"分享成功！"];
//            }else if(response.responseCode == UMSResponseCodeCancel){
////                [ToolsHelper showInfoMessage:@"取消分享"];
//            }
//        }];
//    }
    
  
    
}
//分享积分统计
- (void)shareScore
{
//    [CourseRequest shareScoreWithType:self.sharetype];
}
- (void)showShareView
{
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = screenHeight * .75;
        self.frame = frame;
    }];
    
}

- (void)dismissShareView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = screenHeight;
        self.frame = frame;
    }completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}

@end
