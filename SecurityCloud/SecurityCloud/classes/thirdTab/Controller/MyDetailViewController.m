//
//  MyDetailViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MyDetailViewController.h"
#import "MyQRCodeViewController.h"
#import "InfoDetailCellModel.h"
#import "UserModel.h"
#import "LabelImageTableViewCell.h"
#import "LabelLabelTableViewCell.h"
#import "LabelLitterImageTableViewCell.h"
#import "LableOnlyTableViewCell.h"
#import "BindTelViewController.h"
#import "PersonImageViewController.h"
#import "TextFieldViewController.h"
#import "ScanQRViewController.h"
#import "ChangePasswordViewController.h"
@interface MyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<NSArray<PersonDetailCellModel*>*> *models;
@end

@implementation MyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人详情";
    [self initData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUserInfo];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:MyDetailViewControllerReload object:nil];
    // Do any additional setup after loading the view.
}

-(void)loadUserInfo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"id"];
    [HttpTool post:@"/qingbaoyuandenglu.html" parameters:parameters success:^(id responseObject) {
        self.model = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self initData];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}


-(void)reloadData{
    [self loadUserInfo];
}
-(void)initData {
    [self.models removeAllObjects];
    PersonDetailCellModel *model0 = [[PersonDetailCellModel alloc] initWithTitle:@"头像" showValue:_model.imgurl cellType:CustomPersonCellTypeLabelImage];
    PersonDetailCellModel *model1 = [[PersonDetailCellModel alloc] initWithTitle:@"昵称" showValue:_model.name cellType:CustomPersonCellTypeLabelLabel];
    PersonDetailCellModel *model2 = [[PersonDetailCellModel alloc] initWithTitle:@"我的二维码:" showValue:_model.name cellType:CustomPersonCellTypeLabelLitterImage];
    NSString *changeTel = [UserManager sharedManager].password == nil || [NSString isEmpty:[UserManager sharedManager].password] ? @"绑定手机":@"更换手机";
    PersonDetailCellModel *model3 = [[PersonDetailCellModel alloc] initWithTitle:changeTel showValue:_model.tel cellType:CustomPersonCellTypeLabelOnly];
    
    PersonDetailCellModel *model4 = [[PersonDetailCellModel alloc] initWithTitle:@"修改密码" showValue:_model.tel cellType:CustomPersonCellTypeLabelOnly];
    
    
   
    [self.models addObject:@[model0]];
    if (_model.admin == nil) {
        //群众 无上线
        NSString *str = _model.shangxian == nil ? @"上线: 暂无上线":[NSString stringWithFormat:@"上线:%@",_model.shangxian.name];
        PersonDetailCellModel *model5 = [[PersonDetailCellModel alloc] initWithTitle:str showValue:_model.admin.userID cellType:CustomPersonCellTypeLabelLitterImage];
        [self.models addObject:@[model1,model2,model3,model4,model5]];
    }else{
        [self.models addObject:@[model1,model2,model3,model4]];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    PersonDetailCellModel *model = sections[indexPath.row];
    switch (model.cellType) {
        case CustomPersonCellTypeLabelImage:{
            LabelImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelImageTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"LabelImageTableViewCell" owner:nil options:nil].firstObject;
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case CustomPersonCellTypeLabelLabel:{
            LabelLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelLabelTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"LabelLabelTableViewCell" owner:nil options:nil].firstObject;
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case CustomPersonCellTypeLabelLitterImage:{
            LabelLitterImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelLitterImageTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"LabelLitterImageTableViewCell" owner:nil options:nil].firstObject;
            }
            if (indexPath.row == 3) {
                // 扫一扫
                cell.litterImage.image = [UIImage imageNamed:@"扫一扫"];
            }else{
                cell.litterImage.image = [UIImage imageNamed:@"二维码"];
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case CustomPersonCellTypeLabelOnly:{
            LableOnlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LableOnlyTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"LableOnlyTableViewCell" owner:nil options:nil].firstObject;
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            break;
    }
    LableOnlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LableOnlyTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LableOnlyTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //头像
        PersonImageViewController *vc = [PersonImageViewController new];
        vc.imageUrl = self.model.imgurl;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 0){
        //昵称
        TextFieldViewController *vc = [TextFieldViewController new];
        vc.nameStr = _model.name;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        //我的二维码
       UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyQRCodeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MyQRCodeViewController"];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        //手机绑定
        BindTelViewController *vc = [[BindTelViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        if ([UserManager sharedManager].password == nil || [NSString isEmpty:[UserManager sharedManager].password]) {
            [SVProgressHUD showInfoWithStatus:@"游客无密码，无法修改"];
            return;
        }
        ChangePasswordViewController *vc = [ChangePasswordViewController  new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //扫一扫
        ScanQRViewController *vc = [[ScanQRViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }


}

-(NSMutableArray<NSArray<PersonDetailCellModel *> *> *)models {
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
