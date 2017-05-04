//
//  SinarioMasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "SinarioMasterController.h"
#import "SinarioMasterCell.h"

#import "EditSinarioController.h"

@interface SinarioMasterController ()
@property (strong, nonatomic) IBOutlet DropButton *facilityBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL                    isOpen;

@end

@implementation SinarioMasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.isOpen = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinarioMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinarioMasterCell" forIndexPath:indexPath];
    
    return cell;
    
}

//tableviewcell点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isOpen = YES;
    [self performSegueWithIdentifier:@"pushEditSinarioMaster" sender:self];
}

- (IBAction)addEditSinarioMaster:(UIButton *)sender {
    self.isOpen = NO;
    [self performSegueWithIdentifier:@"pushEditSinarioMaster" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    EditSinarioController *esc = segue.destinationViewController;
    
    if (self.isOpen) {
        esc.labelTitle = @"詳細";
        esc.isEdit = YES;
        
    } else {
        esc.labelTitle = @"新规追加";
        esc.isEdit = NO;
        
    }
}
@end
