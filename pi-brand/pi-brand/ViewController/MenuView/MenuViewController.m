//
//  MenuViewController.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/25.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "MenuTableViewCell2.h"
#import "WebViewController.h"
#import "linkModel.h"
#import "lsitModel.h"


@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView* tableView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIView* footerView;
@property(nonatomic,strong) NSArray* listArray;
@property(nonatomic,strong) NSArray* linkArray;
@end

@implementation MenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [[HTTPRequest instance]PostRequestWithURL:@"http://www.pi-brand.cn/index.php/home/api/menu_list" Parameter:nil succeed:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL succeed = [[responseObject objectForKey:@"status"]boolValue];
        if (succeed) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            [lsitModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id"};
            }];
            [linkModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID" : @"id"};
            }];
            self.listArray = [lsitModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"nav"]];
            self.linkArray = [linkModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"link"]];
            [self.tableView reloadData];
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } netWork:^(BOOL netWork) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        MenuTableViewCell2* cell = [MenuTableViewCell2 createCellWithTableView:tableView];
        [cell addDataWithArray:self.linkArray];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            MenuTableViewCell* cell = [MenuTableViewCell createCellWithTableView:tableView];
            [cell addDataWithUrlString:nil imageNamed:@"list_1"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            if (indexPath.row != 4) {
                MenuTableViewCell* cell = [MenuTableViewCell createCellWithTableView:tableView];
                [cell addDataWithUrlString:self.listArray[indexPath.row - 1] imageNamed:nil];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                MenuTableViewCell* cell = [MenuTableViewCell createCellWithTableView:tableView];
                [cell addDataWithUrlString:nil imageNamed:@"list_5"];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            MainViewController* manVC = [ChildViewController instance].MainVC;
            manVC.titString = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.row];
            [self.sideMenuViewController setContentViewController:[ChildViewController instance].MainNavgation animated:YES];
        }
            break;
        case 1:
        {
            CompanyViewController* companyVC = [ChildViewController instance].companyVC;
            companyVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.row];
            companyVC.leftCount = 1;
            [self.sideMenuViewController setContentViewController:[ChildViewController instance].companyNavgation animated:YES];
        }
            break;
        case 2:
        {
            ProductViewController* productVC = [ChildViewController instance].productVC;
            productVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.row];
            productVC.leftCount = 1;
            [self.sideMenuViewController setContentViewController:[ChildViewController instance].productNavgation animated:YES];
        }
            break;
        case 3:
        {
            JoinusViewController* joinVC = [ChildViewController instance].joinVC;
            joinVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.row];
            joinVC.leftCount = 1;
            [self.sideMenuViewController setContentViewController:[ChildViewController instance].joinNavgation animated:YES];
        }
            break;
        case 4:
        {
//            shopViewController* shopVC = [ChildViewController instance].shopVC;
//            shopVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.row];
//            [self.sideMenuViewController setContentViewController:[ChildViewController instance].shopNavgation animated:YES];
            ProductViewController* productVC = [ChildViewController instance].productVC;
            productVC.title = [NSString stringWithFormat:@"点击了地 %ld cell",indexPath.row];
            productVC.leftCount = 1;
            [self.sideMenuViewController setContentViewController:[ChildViewController instance].productNavgation animated:YES];

        }
            break;
            
        default:
            break;
    }
    [self.sideMenuViewController hideMenuViewController];
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth*4/5, screenHeight/2.5)];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_09"]];
        [_headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.bottom.offset(-15);
        }];
        UIImageView* logoimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_wite"]];
        [_headerView addSubview:logoimageView];
        [logoimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(imageView);
        }];
    }
    return _headerView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, screenWidth*4/5, screenHeight + 64 ) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 5;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
