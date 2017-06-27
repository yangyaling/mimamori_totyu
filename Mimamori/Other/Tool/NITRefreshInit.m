//
//  NITRefreshSet.m
//  Mimamori
//
//  Created by NISSAY IT on 16/8/17.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "NITRefreshInit.h"

@implementation NITRefreshInit


+(MJRefreshNormalHeader *)MJRefreshNormalHeaderInit:(MJRefreshNormalHeader *)header{
    
    if (header) {
        
        // 文字セット
        //プルで更新する
        [header setTitle:@"プルで更新する" forState:MJRefreshStateIdle];
        //放して更新する
        [header setTitle:@"放して更新する" forState:MJRefreshStatePulling];
        //更新中...
        [header setTitle:@"更新中..." forState:MJRefreshStateRefreshing];
        
        // フォントを設定
        header.stateLabel.font = [UIFont systemFontOfSize:15];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        
        // 色をセットにして
        header.stateLabel.textColor = NITColor(166, 166, 166);
        
        // 隠し時間
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // すぐに更新状態に入り
        [header beginRefreshing];
        
    }
    
    return header;
}

+(MJRefreshNormalHeader*)MJRefreshNormalHeaderInitTwo:(MJRefreshNormalHeader*)header {
    if (header) {
        
      
        //プルで更新する
        [header setTitle:@"プルで更新する" forState:MJRefreshStateIdle];
        //放して更新する
        [header setTitle:@"放して更新する" forState:MJRefreshStatePulling];
        //更新中...
        [header setTitle:@"更新中..." forState:MJRefreshStateRefreshing];
        
   
        header.stateLabel.font = [UIFont systemFontOfSize:15];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        
   
        header.stateLabel.textColor = NITColor(166, 166, 166);
        
     
        header.lastUpdatedTimeLabel.hidden = YES;
        

        
    }
    
    return header;
    
}
@end
