//
//  DetailController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/4.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "DetailController.h"



@interface DetailController ()

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *roomID;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *textView;




@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//        [self.pushButton setHidden:NO];
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.borderWidth = 2.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    self.textView.userInteractionEnabled = NO;
    self.textView.editable = NO;
    self.username.text = self.titles;
    self.roomID.text = self.address;
    self.time.text = self.putdate;
    self.textView.text = self.contents;
}



@end
