//
//  SinarioMasterCell.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/2.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "SinarioMasterCell.h"

@interface SinarioMasterCell ()
@property (strong, nonatomic) IBOutlet UILabel *protoid;

@property (strong, nonatomic) IBOutlet UILabel *protoname;

@end

@implementation SinarioMasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    
    self.protoid.text = datasDic[@"protoid"];
    self.protoname.text = datasDic[@"protoname"];
    
}

@end
