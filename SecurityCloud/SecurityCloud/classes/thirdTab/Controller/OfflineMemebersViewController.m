//
//  OfflineMemebersViewController.m
//  SecurityCloud
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "OfflineMemebersViewController.h"
#import "UserManager.h"
#import "OfflineMembersTableViewCell.h"
@interface OfflineMemebersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<UserManager*> *models;

@property (nonatomic,assign) NSInteger page;
@end

@implementation OfflineMemebersViewController

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
    [HttpTool post:@"/api/yonghuxiaxianchakan.html" parameters:parameters success:^(id responseObject) {
        if (_page == 0) {
            [self.models removeAllObjects];
        }
        NSMutableArray<UserManager*> *list =  [UserManager mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
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
    OfflineMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfflineMembersTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OfflineMembersTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = _models[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选项" message:@"操作" preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles = @[@"聊天",@"解绑",@"设置标签"];
    for (NSString *name in titles) {
        [alertC addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([name isEqualToString:@"聊天"]) {
                return ;
            }
            if ([name isEqualToString:@"解绑"]) {
                return ;
            }
            if ([name isEqualToString:@"设置标签"]) {
                return ;
            }
        }]];
        

    }
    
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

-(NSMutableArray<UserManager *> *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}




@end
