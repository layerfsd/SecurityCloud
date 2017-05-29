//
//  MyTagViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MyTagViewController.h"
#import "TagCollectionViewCell.h"
#import "UserManager.h"
#import "TagHeaderCollectionReusableView.h"
@interface MyTagViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;

//@property (nonatomic,strong) NSMutableArray<NSMutableArray<UserLabel*>*> *tags;

@property (nonatomic,strong) NSMutableArray<UserLabel*> *myTags;
@property (nonatomic,strong) NSMutableArray<UserLabel*> *allTags;
@end

@implementation MyTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadData];
    
    // Do any additional setup after loading the view.
}

-(void)loadData {
    
  
    //我的标签
    NSMutableDictionary *parameters0 = [NSMutableDictionary dictionary];
    [parameters0 setValue:UserID forKey:@"id"];
    [HttpTool post:@"/qingbaoyuandenglu.html" parameters:parameters0 success:^(id responseObject) {
        [self.myTags removeAllObjects];
        UserManager *user = [UserManager mj_objectWithKeyValues:responseObject[@"data"]];
       
        for (UserLabel *label in user.biaoqian) {
            [self.myTags addObject:label];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
       
    }];
    
    [self loadAllTags];
}
-(void)loadAllTags{
    //所有标签
    NSDictionary *parameters = @{@"page":@"0",@"fenyeshu":@"100"};
    [HttpTool post:@"/biaoqiancha.html" parameters:parameters success:^(id responseObject) {
        NSArray *count = responseObject[@"count"];
        NSMutableArray *labels = [UserLabel mj_objectArrayWithKeyValuesArray:count];
        
        [self.allTags addObjectsFromArray:labels];
        
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? self.myTags.count:self.allTags.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
    NSMutableArray *sections = indexPath.section == 0 ? self.myTags:self.allTags;
    UserLabel *label = sections[indexPath.item];
    NSString *str = label.biaoti;
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 39) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize cellSize = CGSizeMake(textSize.width + 20 + 5, 39);
    return cellSize;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 30);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.section);
    NSString *CellIdentifier = @"TagHeaderCollectionReusableView";
    //从缓存中获取 Headercell
    TagHeaderCollectionReusableView *cell = (TagHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.x_titleLabel.text = indexPath.section == 0 ? @"我的标签(点击去掉)":@"所有的标签(点击添加)";
    return cell;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *sections = indexPath.section == 0 ? self.myTags:self.allTags;
    UserLabel *label = sections[indexPath.item];
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionViewCell" forIndexPath:indexPath];
    cell.x_titleLabel.text = label.biaoti;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *sections = indexPath.section == 0 ? self.myTags:self.allTags;
    UserLabel *label = sections[indexPath.item];
    if (indexPath.section == 1) {
        //所有标签 添加
        NSDictionary *parameters = @{@"yonghuid": UserID,@"biaoqianid":label.labelID};
        [HttpTool post:@"/yonghubiaoqianbangding.html" parameters:parameters success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [self.allTags removeObject:label];
            [self.myTags addObject:label];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        } failure:^(NSError *error) {
            
        }];
    }else{
        //我的标签 减掉
        NSDictionary *parameters = @{@"yonghuid": UserID,@"biaoqianid":label.labelID};
        [HttpTool post:@"/yonghubiaoqianjiebang.html" parameters:parameters success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [self.myTags removeObject:label];
            [self.allTags addObject:label];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        } failure:^(NSError *error) {
            
        }];
    }
}

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
       
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TagCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TagHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TagHeaderCollectionReusableView"];
    }
    return _collectionView;
}

-(NSMutableArray<UserLabel *> *)myTags {
    if (_myTags == nil) {
        _myTags = [NSMutableArray array];
    }
    return _myTags;
}

-(NSMutableArray<UserLabel *> *)allTags {
    if (_allTags == nil) {
        _allTags = [NSMutableArray array];
    }
    return _allTags;
}

@end
