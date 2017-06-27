//
//  PlaceSettingCell.h
//  Mimamori2
//
//  Created by NISSAY IT on 2017/4/28.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceSettingCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UITextField    *cdName;

@property (nonatomic, strong) NSDictionary            *datasDic;


@property (strong, nonatomic) IBOutlet UITextField    *numCd;

@property (nonatomic, assign) BOOL                    editOp;

@property (nonatomic, assign) NSInteger               cellindex;

@end
