//
//  DraftBoxListViewController.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "DraftBoxListViewController.h"
#import "CoreDataHelper.h"
#import "Info+CoreDataClass.h"
#import "DraftBoxTableViewCell.h"
#import "PostMainViewController.h"
#import "PostModel.h"
#import "ImageModel+CoreDataClass.h"
@interface DraftBoxListViewController ()<UITableViewDelegate,UITableViewDataSource,DeleteCellDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<Info*> *infos;
@end

@implementation DraftBoxListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:DraftBoxListViewControllerNotificationString object:nil];
}

-(void)reloadData:(NSNotification*)noti {
    [self loadData];
    [self.tableView reloadData];
}

-(void)loadData {
    [self.infos removeAllObjects];
    NSArray *infoDatas = [CoreDataHelper getInfos];
    [self.infos addObjectsFromArray:infoDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DraftBoxTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DraftBoxTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.model = _infos[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostMainViewController *vc = [[PostMainViewController alloc] init];
    vc.info = self.infos[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)cancelInfo:(Info*)info {
    if (![NSString isEmpty:info.images]) {
        NSMutableArray *images = [NSMutableArray array];
        NSArray<NSString*> *imageNames = [info.images componentsSeparatedByString:@","];
        for (NSString *imageName in imageNames) {
            ImageModel *imageModel = [ImageModel MR_findByAttribute:@"imageName" withValue:imageName].firstObject;
            UIImage *image = [UIImage imageWithData:imageModel.imageData];
            PostImageModel *model = [[PostImageModel alloc] initWithImage:image imageName:imageName];
            [images addObject:model];
            for (PostImageModel *model in images) {
                ImageModel *imageModel = [ImageModel MR_findByAttribute:@"imageName" withValue:model.imageName].firstObject;
                [imageModel MR_deleteEntity];
            }
        }
        
    }
        
        
    Info *thisInfo = [CoreDataHelper findInfoByTime:info.creatTime];
    [thisInfo MR_deleteEntity];
        
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
    
}

-(void)deleteCell:(NSInteger)index {
    [self cancelInfo:_infos[index]];
    [_infos removeObjectAtIndex:index];
    [self.tableView reloadData];
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

-(NSMutableArray<Info *> *)infos {
    if (_infos == nil) {
        _infos = [NSMutableArray array];
    }
    return _infos;
}

@end
