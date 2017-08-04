//
//  SearchViewController.m
//  31jinfu
//
//  Created by shengtian on 2017/7/27.
//  Copyright © 2017年 刘厚宽. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "searchModel.h"
#import "WebViewController.h"
#import "HotTableViewCell.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *search;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) NSMutableArray* hintArray;
@property (nonatomic, strong) NSMutableArray* historyArray;
@property (nonatomic, strong) UIView* footerView;
@end

@implementation SearchViewController
-(void)dalete{
    [self.historyArray removeAllObjects];
    [UserDefault setObject:self.historyArray forKey:@"history"];
    [UserDefault synchronize];
}

- (IBAction)searchPress:(id)sender {
    UIButton* btn = (UIButton*)sender;
    NSString* string;
    if (btn.titleLabel.text) {
        string = btn.titleLabel.text;
    }else{
        string = _search.text;
        if (_search.text.length<=0) {
            return;
        }
    }
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/search_list" Parameter:@{@"search":string} succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSArray* dataArr = [responseObject objectForKey:@"data"];
            [searchModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id"};
            }];
            self.dataArray = [searchModel mj_objectArrayWithKeyValuesArray:dataArr];
            if (self.dataArray) {
                if (self.historyArray.count<6) {
                    [self.historyArray addObject:string];
                }else{
                    [self.historyArray removeObjectAtIndex:0];
                    [self.historyArray addObject:string];
                }
                [UserDefault setObject:self.historyArray forKey:@"history"];
                [UserDefault synchronize];
                [self.tableView reloadData];
                
            }
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
}
- (IBAction)canclePress:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count) {
        return self.dataArray.count;
    }else
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count>0) {
        return 1;
    }else if (self.historyArray.count>0) {
            return 2;
    }else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        return 0;
    }else
        return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        return nil;
    }else{
        UIView* view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        UILabel* label = [UILabel new];
        [view addSubview:label];
        label.textColor = UICOLOR_RGB_Alpha(0x090909, 1);
        if (section == 0) {
            label.text = @"热门搜索";
        }else{
            label.text = @"历史记录";
        }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.left.offset(20);
            make.bottom.offset(5);
        }];
        return view;
    }
    return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>0) {
        SearchTableViewCell* cell = [SearchTableViewCell createCellWithTableView:tableView];
        [cell addDataWithModel:self.dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HotTableViewCell* cell = [HotTableViewCell createCellWithTableView:tableView];
        if (indexPath.section == 0) {
            [cell addDataWithArray:self.hintArray];
        }else
            [cell addDataWithArray:self.historyArray];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>0) {
        searchModel* modle = self.dataArray[indexPath.row];
        WebViewController* webVC = [[WebViewController alloc]init];
        webVC.MYURL = [modle.url safeUrlString];
        webVC.LeftCount = 2;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.estimatedRowHeight = 5;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    _search.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = self.footerView;
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/search_key" Parameter:@{@"search":_search.text} succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSString* string = [responseObject objectForKey:@"data"];
            self.hintArray = [[string componentsSeparatedByString:@","] mutableCopy];
            [self.tableView reloadData];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
    self.historyArray = [[UserDefault objectForKey:@"history"] mutableCopy];
    if (!_historyArray) {
        _historyArray = [NSMutableArray new];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 65)];
        UIButton* daleteBtn = [UIButton new];
        [_footerView addSubview:daleteBtn];
        [daleteBtn setTitle:@"清空历史" forState:normal];
        daleteBtn.layer.cornerRadius = 5.0;
        daleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        daleteBtn.backgroundColor = UICOLOR_RGB_Alpha(0xeeeeee, 1);
        [daleteBtn setTitleColor:UICOLOR_RGB_Alpha(0x535353, 1) forState:normal];
        [daleteBtn addTarget:self action:@selector(dalete) forControlEvents:UIControlEventTouchUpInside];
        [daleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.width.mas_equalTo(screenWidth*3/5);
            make.height.equalTo(@35);
            make.left.offset(screenWidth/5);
        }];
    }
    return _footerView;
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
