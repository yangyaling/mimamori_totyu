//
//  SinarioMasterCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "SinarioMasterCell.h"

@interface SinarioMasterCell ()
@property (strong, nonatomic) IBOutlet UILabel *protoid;

@property (strong, nonatomic) IBOutlet UILabel *protoname;

@end

@implementation SinarioMasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
//    if (self.editOp) {
    
//        [self.igTextLabel setEnabled:YES];
//        [self.yiniText setEnabled:YES];
//        [self.igName setEnabled:YES];
//        [self.igNameMemo setEnabled:YES];
//        
//        [self.igTextLabel setBackgroundColor:[UIColor whiteColor]];
//        [self.yiniText setBackgroundColor:[UIColor whiteColor]];
//        [self.igName setBackgroundColor:[UIColor whiteColor]];
//        [self.igNameMemo setBackgroundColor:[UIColor whiteColor]];
        
        
//    } else {
//        [self.igTextLabel setEnabled:NO];
//        [self.yiniText setEnabled:NO];
//        [self.igName setEnabled:NO];
//        [self.igNameMemo setEnabled:NO];
//    }
    
    self.protoid.text = datasDic[@"protoid"];
    self.protoname.text = datasDic[@"ptotoname"];
    
}

@end
