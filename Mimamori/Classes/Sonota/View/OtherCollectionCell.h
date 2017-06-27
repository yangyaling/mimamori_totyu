//
//  OtherCollectionCell.h
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellTitle;



+ (instancetype)CellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;

@end
