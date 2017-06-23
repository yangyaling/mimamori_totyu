//
//  OtherCollectionCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "OtherCollectionCell.h"

@implementation OtherCollectionCell


/**
 登録セル

 */
+ (instancetype)CellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"OtherCollectionCell";
    UINib *nib = [UINib nibWithNibName:ID bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:ID];
    
    OtherCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OtherCollectionCell" owner:self options:nil].firstObject;
    }
    return cell;
  
}


@end
