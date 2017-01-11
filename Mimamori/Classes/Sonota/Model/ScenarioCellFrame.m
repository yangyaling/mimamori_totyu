//
//  ScenarioCellFrame.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/10.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "ScenarioCellFrame.h"
#import "Device.h"
@implementation ScenarioCellFrame


-(void)setScenarioM:(Device *)scenarioM {
    _scenarioM = scenarioM;
    
    
    NSDictionary *dicOne = scenarioM.modelArr.firstObject;

    NSDictionary *dicTwo = [scenarioM.modelArr  objectAtIndex:1];

    NSDictionary *dicThree = [scenarioM.modelArr  objectAtIndex:2];

    NSDictionary *dicFour = scenarioM.modelArr.lastObject;
    
    
    if ([dicOne[@"detailno"] integerValue] == 0 && [dicTwo[@"detailno"] integerValue] == 0 && [dicThree[@"detailno"] integerValue] == 0 && [dicFour[@"detailno"] integerValue] == 0){
        self.cellHeight = 0;
    }
    
}



@end
