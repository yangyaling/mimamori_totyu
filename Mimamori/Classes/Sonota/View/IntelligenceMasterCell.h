//
//  IntelligenceMasterCell.h
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/2.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntelligenceMasterCell : UITableViewCell

@property (nonatomic, strong) NSDictionary            *datasDic;
@property (nonatomic, assign) BOOL                    editOp;

@property (nonatomic, assign) NSInteger               cellindex;

@end
