//
//  MsgListViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/29.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MsgListViewController.h"
#import "PostModel.h"
#import "MsgListTableViewCell.h"
#import "DetailInfoViewController.h"
#import "MsgCenterModel.h"
#import "MsgDetailViewController.h"
#define scanW 45
#define scanH 35

@interface MsgListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<MsgCenterModel*> *models;

@property (nonatomic,assign) NSInteger page;
@end

@implementation MsgListViewController
//qingbaoshouliliebiao
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:MsgListViewControllerReload object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:YES];
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(rebackToRootViewAction)];
        
       
    }else{
        self.navigationItem.leftBarButtonItem=nil;
    }
}
- (void)rebackToRootViewAction {
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"push"];
    [pushJudge synchronize];//记得立即同步
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadData:(NSNotification*)noti {
    [self loadData];
    [self.tableView reloadData];
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
    [parameters setValue:UserID forKey:@"yonghuid"];
    [parameters setValue:@(_page) forKey:@"page"];
    [parameters setValue:@(cellNum) forKey:@"fenyeshu"];
    [HttpTool post:@"/xinxizhongxin.html" parameters:parameters success:^(id responseObject) {
        if (_page == 0) {
            [self.models removeAllObjects];
        }
        NSMutableArray<MsgCenterModel*> *list =  [MsgCenterModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
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
    MsgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgListTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MsgListTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = _models[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCenterModel *model = self.models[indexPath.row];
    model.zhuangtai = @"0";
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:model.msgID forKey:@"id"];
    [parameters setValue:UserID forKey:@"yonghuid"];
    [HttpTool post:@"/xinxizhongxinxiangqing.html" parameters:parameters success:^(id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgListViewControllerReload object:nil];
        MsgCenterModel *modelDetail = [MsgCenterModel mj_objectWithKeyValues:responseObject[@"data"][0]];
        MsgDetailViewController *vc = [MsgDetailViewController new];
        vc.contentStr = modelDetail.neirong;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        
    }];
    
    
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

-(NSMutableArray<MsgCenterModel *> *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
