//
//  PickerView.m
//  YLHospital_2.0
//
//  Created by AMed on 15/11/19.
//  Copyright © 2015年 博睿精实. All rights reserved.
//

#import "PickerView.h"


@interface PickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UILabel * tempLabel;
}
@property (nonatomic, strong) UIToolbar * toolbar;
@property (nonatomic, strong) UIControl * overlayView;
@property (nonatomic, strong) UIPickerView * myPickerView;


@end
@implementation PickerView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, screenHeight, screenWidth, 260);
        self.backgroundColor = [UIColor whiteColor];
        _overlayView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _overlayView.backgroundColor =[UIColor blackColor];
        [_overlayView setAlpha:.6];
        [_overlayView addTarget:self action:@selector(touchBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.toolbar];
    }
    return self;
}

- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
        _toolbar.barTintColor = [UIColor whiteColor];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(finishInput:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        UILabel * label = [[UILabel alloc]init];
        label.text = @"职称选择";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(0, 0, 150, 44);
        UIBarButtonItem * labelBarItem = [[UIBarButtonItem alloc] initWithCustomView:label];
        tempLabel = label;
        [_toolbar setItems:[NSArray arrayWithObjects:leftBarItem,flex,labelBarItem,flex,rightBarItem,nil]];
    }
    return _toolbar;
}
- (void)finishInput:(UIButton *)bar
{
    if ([self.delegate respondsToSelector:@selector(pickerView:index:)]) {
        [self.delegate pickerView:self index:[self.myPickerView selectedRowInComponent:0]];
    }
    
    [self dismiss];
}

- (void)touchBackAction:(UIControl *)control
{
    [self dismiss];
}
- (void)show
{
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = screenHeight - 260+20;
        self.frame = frame;
    }];
}

- (void)dismiss
{
    [self.myPickerView removeFromSuperview];
    [self removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = screenHeight + 260+20;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        [_overlayView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    tempLabel.text = @"我是中间label";
    [self addSubview:self.myPickerView];
    [self show];
}
- (UIPickerView *)myPickerView
{
    if (!_myPickerView) {
        _myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, screenWidth,260-44)];
        _myPickerView.delegate = self;
        _myPickerView.dataSource = self;
    }
    return _myPickerView;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [_dataArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _dataArray[row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

@end
