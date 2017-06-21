//
//  FirstViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "FirstViewController.h"
#import "RecordSoundView.h"
#import "FirstTabCellModel.h"
#import "FirstCollectionViewCell.h"
#import "PostMainViewController.h"
#import "CoreDataHelper.h"
#import "DraftBoxListViewController.h"
#import "PostedListViewController.h"
#import "VerticalButton.h"
#import "ScanQRViewController.h"
#import "MsgListViewController.h"
#import "AdminHanderListViewController.h"
#import "AdoptedListViewController.h"
#import "WZLBadgeImport.h"
#define cellW (kScreenWidth-20) / _column
#define cellH cellW * 100 / 80.0
#define scanW 45
#define scanH 35
@interface FirstViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@property (nonatomic,strong) NSMutableArray *models;

@property (nonatomic,assign) NSInteger column;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModels];
    [self initCollectionView];
//    [self setNaviItem];
    [self updateNotice];
//    [self loadRedCount];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRedCount];
}

-(void)loadRedCount {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"yonghuid"];
    [HttpTool postWithoutOK:@"/xinxizhongxinweidu.html" parameters:parameters success:^(id responseObject) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
        NSInteger unReadCount = [responseObject[@"count"] integerValue];
//        unReadCount = 8;
        if (cell) {
            for (UIView *item in cell.contentView.subviews) {
                if ([item isKindOfClass:[UILabel class]]) {
                    [item showBadgeWithStyle:WBadgeStyleNumber value:unReadCount animationType:WBadgeAnimTypeNone ];
                    item.badgeCenterOffset = CGPointMake(-8, -5);
                }
            }
            
        }
        
        
        
    } failure:^(NSError *error) {
        
                
    }];

    //qingbaoshoulitongji
    if (_models.count <= 4) {
        return;
    }
    NSMutableDictionary *parameters0 = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"adminid"];
    [HttpTool postWithoutOK:@"/qingbaoshoulitongji.html" parameters:parameters0 success:^(id responseObject) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
        NSInteger unReadCount = [responseObject[@"count"] integerValue];
        //        unReadCount = 8;
        if (cell) {
            for (UIView *item in cell.contentView.subviews) {
                if ([item isKindOfClass:[UILabel class]]) {
                    [item showBadgeWithStyle:WBadgeStyleNumber value:unReadCount animationType:WBadgeAnimTypeNone ];
                    item.badgeCenterOffset = CGPointMake(-8, -5);
                }
            }
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];

}

-(void)setNaviItem {
    CGRect frame = CGRectMake(0, 0, scanW, scanH);
    VerticalButton *button = [[VerticalButton alloc] initWithFrame:frame];
    [button addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    [button setImageAndTitle:[UIImage imageNamed:@"hope_scan"] title:@"扫一扫"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)scan:(UIButton*)btn {
    ScanQRViewController *vc = [[ScanQRViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initModels {
    if ([UserManager sharedManager].admin == nil) {
        //群众
        _column = 4;
    }else{
        _column = 5;
    }
    FirstTabCellModel *model0 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:@"草稿箱"];
    
    FirstTabCellModel *model1 = [[FirstTabCellModel alloc] initWithTitle:@"已上传" image:@"已上传"];
    
    FirstTabCellModel *model2 = [[FirstTabCellModel alloc] initWithTitle:@"被采用" image:@"被采用"];
    
    FirstTabCellModel *model3 = [[FirstTabCellModel alloc] initWithTitle:@"消息中心" image:@"信息中心"];
    
    FirstTabCellModel *model4 = [[FirstTabCellModel alloc] initWithTitle:@"待处理" image:@"待处理"];
    
    if ([UserManager sharedManager].admin == nil) {
        //群众
        _column = 4;
         [self.models addObjectsFromArray:@[model0,model1,model2,model3]];
    }else{
        _column = 5;
         [self.models addObjectsFromArray:@[model0,model1,model2,model3,model4]];
    }
    
   
}
-(void)initCollectionView {
    NSInteger row = ((self.models.count - 1) / _column) + 1;
    _flowLayout.itemSize = CGSizeMake(cellW, cellH);
    _collectionViewHeightConstraint.constant = row * cellH;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FirstCollectionViewCell"];
}

- (IBAction)pressed:(UIButton *)sender {
    PostMainViewController *vc = [[PostMainViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCell" forIndexPath:indexPath];
    FirstTabCellModel *model = self.models[indexPath.item];
    cell.model = model;
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //点击事件
    if (indexPath.item == 0) {
        //草稿箱
        DraftBoxListViewController *draftBoxListViewController = [[DraftBoxListViewController alloc] init];
        [self.navigationController pushViewController:draftBoxListViewController animated:YES];
        
    }
    if (indexPath.item == 1) {
        //已上传箱
        PostedListViewController *postedListViewController = [[PostedListViewController alloc] init];
        [self.navigationController pushViewController:postedListViewController animated:YES];
        
    }
    if (indexPath.item == 2) {
        //被采用
        AdoptedListViewController *vc = [[AdoptedListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.item == 3) {
        //信息中心
        
        MsgListViewController *vc = [[MsgListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.item == 4) {
        //待处理
        AdminHanderListViewController *vc = [[AdminHanderListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark update 
-(void)updateNotice {
    [HttpTool post:@"/appbanben.html" parameters:nil success:^(id responseObject) {
        NSString *appVersion = @"";
        NSArray *versions = responseObject[@"data"];
        for (NSDictionary *temp in versions) {
            if ([temp[@"apppingtai"] isEqual:@"ios"]) {
                appVersion = temp[@"appverson"];
            }
        }
        NSString* app_version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        if ([app_version compare:appVersion] == NSOrderedAscending) {
            //更新
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新版本可以更新" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //确认更新
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];

                
            }];
            [alert addAction:cancel];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
 
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
