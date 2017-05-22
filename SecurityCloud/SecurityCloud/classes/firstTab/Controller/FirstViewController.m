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
#define colum 5
#define cellW kScreenWidth / colum
#define cellH cellW * 100 / 80.0
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
    
    _postButton.layer.masksToBounds = YES;
    _postButton.layer.cornerRadius = _postButton.frame.size.width * 0.5;
}

-(void)initModels {
    FirstTabCellModel *model0 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:nil];
    
    FirstTabCellModel *model1 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:nil];
    
    FirstTabCellModel *model2 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:nil];
    
    FirstTabCellModel *model3 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:nil];
    
    FirstTabCellModel *model4 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:nil];
    
    FirstTabCellModel *model5 = [[FirstTabCellModel alloc] initWithTitle:@"草稿箱" image:nil];
    
    [self.models addObjectsFromArray:@[model0,model1,model2,model3,model4,model5]];
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
