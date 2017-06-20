//
//  TopNoticeTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "TopNoticeTableViewCell.h"
#import "MsgModel.h"
#import "NoticeInsideTableViewCell.h"
#import "InfoDetailCellModel.h"
#import "NoticeTableViewCell.h"
@interface TopNoticeTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableIView;

@end
@implementation TopNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(NoticeModel *)model {
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.tubiao] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _subLabel.text = _model.biaoti;
    [self.tableIView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_model) {
        return _model.zixunliebiao.count;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69.0 / 2;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgLitterModel *model = _model.zixunliebiao[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(msgCliked:)]) {
        [_delegate msgCliked:model];
    }
}
@end
