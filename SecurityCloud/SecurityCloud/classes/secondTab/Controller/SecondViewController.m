//
//  SecondViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "SecondViewController.h"
#import "MsgModel.h"
#import "NoticeTableViewCell.h"
#import "TopNoticeTableViewCell.h"
#import "SDCycleScrollView.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) NSMutableArray<NoticeModel*> *noticeList;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadDataFromServer];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataFromServer];
    }];
    
    CGRect titleFrame = CGRectMake(0, 0, kScreenWidth, 150);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:titleFrame delegate:self placeholderImage:[UIImage imageNamed:@""]];
    self.tableView.tableHeaderView = cycleScrollView;
//    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
}

-(void)loadDataFromServer {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"userID"];
    
    [HttpTool post:@"/zixunzhuliebiao.html" parameters:parameters success:^(id responseObject) {
       
        
        NSDictionary *data = responseObject[@"data"];
        self.model = [MsgModel mj_objectWithKeyValues:data];
        [self.noticeList removeAllObjects];
        [self.noticeList addObjectsFromArray:self.model.liebiao];
        [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
         [self.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark images
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}


#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_model) {
        return 1 + self.noticeList.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TopNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopNoticeTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TopNoticeTableViewCell" owner:nil options:nil].firstObject;
        }
        cell.model = _model.gonggao;
        return cell;
    }else{
        NoticeModel *model = self.noticeList[indexPath.section - 1];
        NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:nil options:nil].firstObject;
        }
        cell.model = model;
        return cell;

    }
    
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(NSMutableArray<NoticeModel *> *)noticeList {
    if (_noticeList == nil) {
        _noticeList = [NSMutableArray array];
    }
    return _noticeList;
}

@end
