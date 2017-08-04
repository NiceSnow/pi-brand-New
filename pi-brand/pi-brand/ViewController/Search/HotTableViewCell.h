//
//  HotTableViewCell.h
//  pi-brand
//
//  Created by Madodg on 2017/8/4.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTableViewCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
-(void)addDataWithArray:(NSMutableArray*)array;
@end
