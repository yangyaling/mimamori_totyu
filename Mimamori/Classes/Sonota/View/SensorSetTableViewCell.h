//
//  SensorSetTableViewCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NowRloadDelegate <NSObject>

- (void)NowRefreshScreen;

@end


@interface SensorSetTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NowRloadDelegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel             *sensorname;


@property (strong, nonatomic) IBOutlet UITextField         *roomname;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *segmentbar;

@property (nonatomic, copy) NSString                       *nodeid;

@property(nonatomic, assign) BOOL SuperEdit;

@property (nonatomic, assign) NSInteger                    cellnumber;

@property (strong, nonatomic) IBOutlet UIButton            *pickBtn;


@end
