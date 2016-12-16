//
//  OtherCollectionCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "OtherCollectionCell.h"

@implementation OtherCollectionCell

+ (instancetype)CellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *ID = @"OtherCell";
//    UINib *nib = [UINib nibWithNibName:ID bundle:nil];
//    [collectionView registerNib:nib forCellWithReuseIdentifier:ID];
//    OtherCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
  
    return [self cellFromNib:nil andCollectionView:collectionView andIndexPath:indexPath];
}


+ (instancetype)cellFromNib:(NSString *)nibName andCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([self class]);
    
    NSString *ID = nibName == nil? className : nibName;
    
    UINib *nib = [UINib nibWithNibName:ID bundle:nil];
    
    [collectionView registerNib:nib forCellWithReuseIdentifier:ID];
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
}

@end
