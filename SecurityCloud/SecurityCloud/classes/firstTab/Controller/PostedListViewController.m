//
//  PostedListViewController.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "PostedListViewController.h"
#import "CoreDataHelper.h"
#import "Info+CoreDataClass.h"
#import "DraftBoxTableViewCell.h"
#import "PostMainViewController.h"
#import "PostModel.h"
#import "PostedInfoTableViewCell.h"
#define cellNum 10
@interface PostedListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<PostModel*> *infos;

@property (nonatomic,assign) NSInteger page;


@end

@implementation PostedListViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:PostedListViewControllerNotificationString object:nil];
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
    [HttpTool post:@"/qingbaoliebiao.html" parameters:parameters success:^(id responseObject) {
        if (_page == 0) {
            [self.infos removeAllObjects];
        }
        NSMutableArray<PostModel*> *list =  [PostModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.infos addObjectsFromArray:list];
       
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
    return _infos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostedInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostedInfoTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PostedInfoTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = _infos[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //详情
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

-(NSMutableArray<PostModel *> *)infos {
    if (_infos == nil) {
        _infos = [NSMutableArray array];
    }
    return _infos;
}

@end

