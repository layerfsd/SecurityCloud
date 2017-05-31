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
#import "MyQRCodeViewController.h"
#import "MyDetailViewController.h"
#import "MyTagViewController.h"
#import "ScoreCountListViewController.h"
#import <UShareUI/UShareUI.h>
#import "RankingViewController.h"
@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource,MeHeadTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray<NSArray<MeCellData*>*> *datas;

@property (strong,nonatomic) UserModel *userModel;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    _tableView.estimatedRowHeight = 80;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUserInfo];
    }];
    [self loadUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:FirstViewControllerReload object:nil];
}

-(void)reloadData {
    [self loadUserInfo];
}

-(void)initDatas {
    NSArray *section0 = @[[MeCellData initWithTitle:@"我的标签" imageName:@"我的标签"],
                          [MeCellData initWithTitle:@"积分统计" imageName:@"积分统计"]];
    
    NSArray *section1 = @[[MeCellData initWithTitle:@"积分排行" imageName:@"积分排行"],
                          /*[MeCellData initWithTitle:@"版本更新" imageName:@"版本更新"],*/
                          [MeCellData initWithTitle:@"关于APP" imageName:@"关于APP"],
                          [MeCellData initWithTitle:@"推荐给好友" imageName:@"推荐给好友"],
                          [MeCellData initWithTitle:@"退出登录" imageName:@"退出"]];
    [self.datas addObject:section0];
    [self.datas addObject:section1];
}

-(void)loadUserInfo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"id"];
    [HttpTool post:@"/qingbaoyuandenglu.html" parameters:parameters success:^(id responseObject) {
        self.userModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
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
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = self.datas[indexPath.section - 1][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //个人信息
        MyDetailViewController *vc = [[MyDetailViewController alloc] init];
        vc.model = self.userModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSArray *sections = self.datas[indexPath.section - 1];
        MeCellData *model = sections[indexPath.row];
        if ([model.titleStr isEqualToString:@"我的标签"]) {
            MyTagViewController *vc = [MyTagViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.titleStr isEqualToString:@"我的标签"]){
            
        }else if ([model.titleStr isEqualToString:@"积分统计"]){
            ScoreCountListViewController *vc = [ScoreCountListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.titleStr isEqualToString:@"积分排行"]){
            RankingViewController *vc = [RankingViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.titleStr isEqualToString:@"版本更新"]){
            
        }else if ([model.titleStr isEqualToString:@"关于APP"]){
            [SVProgressHUD showInfoWithStatus:@"龙防云是一款适合所有人使用，并且可以与民警合作的应用"];
        }else if ([model.titleStr isEqualToString:@"推荐给好友"]){
            [self recommand];
        }else if ([model.titleStr isEqualToString:@"退出登录"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //确认退出
                if([UserManager deleteFile]){
                    [[UserManager sharedManager] goToLogin];
                }
            }];
            [alert addAction:cancel];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

-(void)recommand {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"推荐您使用龙防云" descr:@"龙防云是一款适合所有人使用，并且可以与民警合作的应用" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",@"http://cntp31.lysoo.com/guanli/index.php/Admin/yaoqing/zhuceyaoqing/yaoqingid/",UserID];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
        }];
    }];

}

-(void)QRClicked {
    //
    [self performSegueWithIdentifier:@"ToQRCode" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToQRCode"]) {
        MyQRCodeViewController *vc = segue.destinationViewController;
        vc.model = _userModel;
    }
}

-(NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


@end
