//
//  MoreMsgListViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/28.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MoreMsgListViewController.h"
#import "MsgModel.h"
#import "RxWebViewController.h"
#import "MoreMsgListTableViewCell.h"
@interface MoreMsgListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<MsgLitterModel*> *models;

@property (nonatomic,assign) NSInteger page;
@end

@implementation MoreMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNew];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    [self loadNew];
}


-(void)loadNew {
    _page = 0;
    
    [self loadData];
}

-(void)loadMore {
    
    
    [self loadData];
}

-(void)loadData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_noticeID forKey:@"fenlei"];
    [parameters setValue:@(_page) forKey:@"page"];
    [parameters setValue:@(cellNum) forKey:@"fenyeshu"];
    [HttpTool post:@"/zixunliebiao.html" parameters:parameters success:^(id responseObject) {
        if (_page == 0) {
            [self.models removeAllObjects];
        }
        NSMutableArray<MsgLitterModel*> *list =  [MsgLitterModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.models addObjectsFromArray:list];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (list.count < cellNum) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_page == 0) {
            [self.tableView.mj_footer resetNoMoreData];
        }
        if (list.count == cellNum) {
            _page++;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgLitterModel *model = self.models[indexPath.row];
    MoreMsgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreMsgListTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MoreMsgListTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //详情
    MsgLitterModel *model = self.models[indexPath.row];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",webUrl,model.msgLitterID];
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
    webViewController.titleStr = model.fenlei;
    webViewController.imageUrl = model.img;
    webViewController.contentStr = model.biaoti;
    
    [self.navigationController pushViewController:webViewController animated:YES];
}
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(NSMutableArray<MsgLitterModel *> *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
