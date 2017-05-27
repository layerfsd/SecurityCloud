//
//  DetailInfoViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "PostModel.h"
#import "InfoDetailCellModel.h"
#import "LabelTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "ImagesTableViewCell.h"
#import "AdoptedTableViewCell.h"
@interface DetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<NSArray<InfoDetailCellModel*>*> *models;
@end

@implementation DetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报详情";
    [self initData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)initData {
    InfoDetailCellModel *model0 = [[InfoDetailCellModel alloc] initWithTitle:@"情报级别:" showValue:_model.jibie cellType:CustomCellTypeLabel];
    InfoDetailCellModel *model1 = [[InfoDetailCellModel alloc] initWithTitle:@"情报类别:" showValue:_model.leibie cellType:CustomCellTypeLabel];
    InfoDetailCellModel *model2 = [[InfoDetailCellModel alloc] initWithTitle:@"关键字:" showValue:_model.guanjianzi cellType:CustomCellTypeLabel];
    InfoDetailCellModel *model3 = [[InfoDetailCellModel alloc] initWithTitle:@"发布时间:" showValue:_model.time cellType:CustomCellTypeLabel];
    InfoDetailCellModel *model4 = [[InfoDetailCellModel alloc] initWithTitle:@"情报内容:" showValue:_model.neirong cellType:CustomCellTypeLabel];
    InfoDetailCellModel *model5 = [[InfoDetailCellModel alloc] initWithTitle:@"情报录音:" showValue:_model.luyin cellType:CustomCellTypeButton];
    NSMutableArray *imgurls = [NSMutableArray array];
    for (FileModel *model in _model.imgchakan) {
        [imgurls addObject:model.url];
    }
    InfoDetailCellModel *model6 = [[InfoDetailCellModel alloc] initWithTitle:@"情报图片:" showValue:imgurls cellType:CustomCellTypeImages];
    [self.models addObject:@[model0,model1,model2,model3,model4,model5,model6]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sections = self.models[section];
    return sections.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.models[indexPath.section];
    InfoDetailCellModel *model = sections[indexPath.row];
    switch (model.cellType) {
        case CustomCellTypeLabel:{
            LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:nil options:nil].firstObject;
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case CustomCellTypeButton:{
            ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"ButtonTableViewCell" owner:nil options:nil].firstObject;
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case CustomCellTypeImages:{
            ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImagesTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"ImagesTableViewCell" owner:nil options:nil].firstObject;
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case CustomCellTypeAdopted:{
            AdoptedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdoptedTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"AdoptedTableViewCell" owner:nil options:nil].firstObject;
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            break;
    }
    LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSMutableArray<NSArray<InfoDetailCellModel *> *> *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
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

@end
