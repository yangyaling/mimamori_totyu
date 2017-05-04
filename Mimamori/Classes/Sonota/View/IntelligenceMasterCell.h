//
//  IntelligenceMasterCell.h
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntelligenceMasterCell : UITableViewCell

@property (nonatomic, strong) NSDictionary            *datasDic;
@property (nonatomic, assign) BOOL                    editOp;

@property (nonatomic, assign) NSInteger               cellindex;

@end
