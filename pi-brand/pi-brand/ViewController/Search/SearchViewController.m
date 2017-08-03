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

@end

@implementation SearchViewController
- (IBAction)searchPress:(id)sender {
    if (_search.text.length<=0) {
        return;
    }
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/search_list" Parameter:@{@"search":_search.text} succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSArray* dataArr = [responseObject objectForKey:@"data"];
            [searchModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id"};
            }];
            self.dataArray = [searchModel mj_objectArrayWithKeyValuesArray:dataArr];
            if (self.dataArray) {
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
    if (_hintArray.count>0) {
        return 2;
    }else
        return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        return nil;
    }else{
        UIView* view = [UIView new];
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
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    searchModel* modle = self.dataArray[indexPath.row];
    WebViewController* webVC = [[WebViewController alloc]init];
    webVC.MYURL = [modle.url safeUrlString];
    webVC.LeftCount = 2;
    [self.navigationController pushViewController:webVC animated:YES];
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
    _hintArray = [@[@"hafou",@"hafou",@"hafou",@"hafou",@"hafou",@"hafou"]mutableCopy];
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/search_key" Parameter:@{@"search":_search.text} succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSArray* dataArr = [responseObject objectForKey:@"data"];
            [searchModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id"};
            }];
            self.dataArray = [searchModel mj_objectArrayWithKeyValuesArray:dataArr];
            if (self.dataArray) {
                [self.tableView reloadData];
            }
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
