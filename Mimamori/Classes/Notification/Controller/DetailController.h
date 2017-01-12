//
//  DetailController.h
//  Mimamori2
//
//  Created by totyu2 on 2017/1/4.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailController : UIViewController



@property (nonatomic, strong) NSString                         *titles;

@property (nonatomic, strong) NSString                         *address;

@property (nonatomic, strong) NSString                         *putdate;

@property (nonatomic, strong) NSString                         *contents;




/**
    usernumber
 */
@property (nonatomic, assign) NSInteger                           usernumber;

/**
   type
 */
@property (nonatomic, assign) NSInteger                           type;


@property (nonatomic, assign) BOOL              isanauto;



@end
