//
//  EditSinarioController.h
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/2.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSinarioController : UITableViewController

@property (nonatomic, copy) NSString                      *labelTitle;

@property (nonatomic, assign) BOOL                         isEdit; //詳細（追加）

@property (nonatomic, copy) NSString                      *maxid;  //追加の有効ID

@end
