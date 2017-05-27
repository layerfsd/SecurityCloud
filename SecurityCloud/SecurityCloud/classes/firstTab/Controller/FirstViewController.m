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
#define colum 5
#define cellW (kScreenWidth-20) / colum
#define cellH cellW * 100 / 80.0
#define scanW 45
#define scanH 35
@interface FirstViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@property (nonatomic,strong) NSMutableArray *models;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModels];
    [self initCollectionView];
    [self setNaviItem];
   
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
    FirstTabCellModel *model0 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:@"草稿箱"];
    
    FirstTabCellModel *model1 = [[FirstTabCellModel alloc] initWithTitle:@"已上传" image:@"已上传"];
    
    FirstTabCellModel *model2 = [[FirstTabCellModel alloc] initWithTitle:@"被采用" image:@"被采用"];
    
    FirstTabCellModel *model3 = [[FirstTabCellModel alloc] initWithTitle:@"信息中心" image:@"信息中心"];
    
    FirstTabCellModel *model4 = [[FirstTabCellModel alloc] initWithTitle:@"待处理" image:@"待处理"];
    
   
    
    [self.models addObjectsFromArray:@[model0,model1,model2,model3,model4]];
}
-(void)initCollectionView {
    NSInteger row = ((self.models.count - 1) / colum) + 1;
    _flowLayout.itemSize = CGSizeMake(cellW, cellH);
    _collectionViewHeightConstraint.constant = row * cellH;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FirstCollectionViewCell"];
}

- (IBAction)pressed:(UIButton *)sender {
    PostMainViewController *vc = [[PostMainViewController alloc] init];
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
        //草稿箱
        PostedListViewController *postedListViewController = [[PostedListViewController alloc] init];
        [self.navigationController pushViewController:postedListViewController animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
