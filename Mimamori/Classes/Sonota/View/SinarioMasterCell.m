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
    
    
    self.protoid.text = datasDic[@"protoid"];
    self.protoname.text = datasDic[@"protoname"];
    
}

@end
