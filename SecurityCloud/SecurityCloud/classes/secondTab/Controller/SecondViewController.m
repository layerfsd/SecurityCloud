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
#import "RxWebViewController.h"
#import "MoreMsgListViewController.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,MsgClikedDelegate,MoreMsgClickedDelegate>
@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) NSMutableArray<NoticeModel*> *noticeList;

@property (nonatomic,strong) NSMutableArray<MsgLitterModel*> *banners;


@property (nonatomic,strong) SDCycleScrollView *bannerView;
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
    
    CGRect titleFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9/16);
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:titleFrame delegate:self placeholderImage:[UIImage imageNamed:@""]];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.tableView.tableHeaderView = _bannerView;
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
    
    NSMutableDictionary *parameters0 = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"userID"];
    
    [HttpTool post:@"/zixunguanggao.html" parameters:parameters0 success:^(id responseObject) {
        
        
        NSArray *data = responseObject[@"data"];
        NSMutableArray *datas = [MsgLitterModel mj_objectArrayWithKeyValuesArray:data];
        [self.banners removeAllObjects];
        [self.banners addObjectsFromArray:datas];
        NSMutableArray *imageUrls = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        for (MsgLitterModel *model in self.banners) {
            [imageUrls addObject:model.img];
            [titles addObject:model.biaoti];
        }
     
        _bannerView.titlesGroup = titles;
        _bannerView.imageURLStringsGroup = imageUrls;
        self.tableView.tableHeaderView = _bannerView;
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
    MsgLitterModel *model = self.banners[index];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",webUrl,model.msgLitterID];
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
    [self.navigationController pushViewController:webViewController animated:YES];
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
        cell.delegate = self;
        cell.model = _model.gonggao;
        return cell;
    }else{
        NoticeModel *model = self.noticeList[indexPath.section - 1];
        NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:nil options:nil].firstObject;
        }
        cell.delegate = self;
        cell.actionDelegate = self;
        cell.model = model;
        return cell;

    }
    
}

#pragma mark msgClickedDelegate

-(void)msgCliked:(NSString *)msgID {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",webUrl,msgID];
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)moreMsgClicked:(NSString *)msgID {
    //更多
    MoreMsgListViewController *vc = [MoreMsgListViewController new];
    vc.noticeID = msgID;
    [self.navigationController pushViewController:vc animated:YES];
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

-(NSMutableArray<MsgLitterModel *> *)banners {
    if (_banners == nil) {
        _banners = [NSMutableArray array];
    }
    return _banners;
}

@end
