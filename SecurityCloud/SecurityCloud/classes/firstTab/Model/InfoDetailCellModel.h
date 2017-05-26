//
//  InfoDetailCellModel.h
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,CustomCellType){
    CustomCellTypeLabel = 0,
    CustomCellTypeImages = 1,
    CustomCellTypeButton = 2,
    CustomCellTypeAdopted = 3,
};

@interface InfoDetailCellModel : NSObject
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) id showValue;
@property (nonatomic,assign) CustomCellType cellType;

//多的数据可放这
@property (nonatomic,strong) id moreValue;

-(instancetype)initWithTitle:(NSString*)title showValue:(id)showValue cellType:(CustomCellType)type;
@end
