//
//  NoticeTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "MsgModel.h"
#import "LabelLabelTableViewCell.h"
#import "InfoDetailCellModel.h"
@interface NoticeTableViewCell()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *x_titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(NoticeModel *)model {
    _model = model;
    _x_titleLabel.text = _model.biaoti;
    [_iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_model.tubiao] placeholderImage:nil];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model) {
        return _model.zixunliebiao.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgLitterModel *model = _model.zixunliebiao[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentNotice"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ContentNotice"];
    }
    cell.textLabel.text = model.biaoti;
    cell.detailTextLabel.text = model.time;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 / 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //详情页
}

- (IBAction)moreClicked:(UIButton *)sender {
}

@end
