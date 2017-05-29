//
//  NoticeTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "MsgModel.h"
#import "NoticeInsideTableViewCell.h"
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
    [_iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_model.tubiao] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
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
    NoticeInsideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeInsideTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NoticeInsideTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.x_titleLabel.text = model.biaoti;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 / 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //详情页
    MsgLitterModel *model = _model.zixunliebiao[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(msgCliked:)]) {
        [_delegate msgCliked:model.msgLitterID];
    }
}

- (IBAction)moreClicked:(UIButton *)sender {
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(moreMsgClicked:)]) {
        [_actionDelegate moreMsgClicked:_model.noticeID];
    }
    
}

@end
