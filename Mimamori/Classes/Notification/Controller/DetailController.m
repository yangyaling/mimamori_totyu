//
//  DetailController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/4.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "DetailController.h"

@interface DetailController ()

@property (strong, nonatomic) IBOutlet UILabel *username;

@property (strong, nonatomic) IBOutlet UILabel *roomID;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIButton *pushButton;

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.pushButton.layer.cornerRadius = 6;
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.borderWidth = 2.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.textView.userInteractionEnabled = NO;
    self.textView.editable = NO;
    
    if (self.isanauto) {
        [self.pushButton setHidden:NO];
    } else {
        [self.pushButton setHidden:YES];
    }
    
    self.username.text = self.titles;
    self.roomID.text = self.address;
    self.time.text = self.putdate;
    self.textView.text = self.contents;
    
}


@end
