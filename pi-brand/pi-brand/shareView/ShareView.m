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
    
    for (NSInteger i = 0; i < 2; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:i+10101];
        button.frame = CGRectMake(((CGRectGetWidth(self.frame)/2)*i)+(CGRectGetWidth(self.frame)/2)/2-30, 45, 60, 60);
        UILabel * label = (UILabel *)[self viewWithTag:i+100000];
        label.frame = CGRectMake(CGRectGetWidth(self.frame)/2*i, CGRectGetMaxY(button.frame), CGRectGetWidth(self.frame)/2, 20);
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
    NSInteger tag = btn.tag -10101;
    
    if (tag == 0){
        [self shareWithType:UMSocialPlatformType_WechatSession];
    }else if (tag == 1) {
        [self shareWithType:UMSocialPlatformType_WechatTimeLine];
    }
    
    [self dismissShareView];
}

- (void)shareWithType:(UMSocialPlatformType)platformType

{
//    if (self.sharetype) {
//        [self shareScore];
//    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[self ViewController] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
    
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
