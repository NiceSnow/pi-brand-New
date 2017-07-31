//
//  PickerView.h
//  YLHospital_2.0
//
//  Created by AMed on 15/11/19.
//  Copyright © 2015年 博睿精实. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerView;



@protocol PickerViewDelegte <NSObject>

- (void)pickerView:(PickerView *)pickerView  index:(NSInteger)index;

@end
@interface PickerView : UIView

@property (nonatomic)id<PickerViewDelegte>delegate;

@property (nonatomic, strong)NSMutableArray * dataArray;

@end
