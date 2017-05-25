//
//  ThirdViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ThirdViewController.h"
#import "MeCellData.h"
#import "MeHeadTableViewCell.h"
#import "MeTableViewCell.h"
#import "UserModel.h"
@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray<NSArray<MeCellData*>*> *datas;

@property (strong,nonatomic) UserModel *userModel;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    _tableView.estimatedRowHeight = 80;
    
    [self loadUserInfo];
}

-(void)initDatas {
    NSArray *section0 = @[[MeCellData initWithTitle:@"我的标签" imageName:@""],
                          [MeCellData initWithTitle:@"我的上报" imageName:@""]];
    
    NSArray *section1 = @[[MeCellData initWithTitle:@"联系我们" imageName:@""],
                          [MeCellData initWithTitle:@"系统设置" imageName:@""],
                          [MeCellData initWithTitle:@"关于APP" imageName:@""],
                          [MeCellData initWithTitle:@"推荐给好友" imageName:@""],
                          [MeCellData initWithTitle:@"意见反馈" imageName:@""]];
    [self.datas addObject:section0];
    [self.datas addObject:section1];
}

-(void)loadUserInfo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"id"];
    [HttpTool post:@"/qingbaoyuandenglu.html" parameters:parameters success:^(id responseObject) {
        self.userModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.datas[section-1].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MeHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeHeadTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MeHeadTableViewCell" owner:nil options:nil].firstObject;
        }
        cell.model = self.userModel;
        return cell;
    }
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = self.datas[indexPath.section - 1][indexPath.row];
    return cell;
}

-(NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


@end
