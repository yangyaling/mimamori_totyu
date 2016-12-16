//
//  SetController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SetController.h"

#import "SetTableViewCell.h"

#import "SensorController.h"

@interface SetController ()

@property (nonatomic, strong) NSArray                  *userarray;

@property (nonatomic, strong) NSArray                  *numarray;

@end

@implementation SetController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.userarray = @[@"xxxxx名（1棟6号室）"];
    
    self.numarray = @[@"C1",@"D1",@"M1"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"setcellpush"]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        NSString *strtit = self.userarray[indexPath.row];
        //
        SensorController *ssc = segue.destinationViewController;
        
        ssc.title = strtit;
        
        ssc.sensors = self.numarray.copy;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetTableViewCell *cell = [SetTableViewCell cellWithTableView:tableView];
    
    cell.userinfolabel.text = self.userarray[indexPath.row];
    
    cell.sensernumber.text = @"3";
    
    return cell;
}


//tableviewcell点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"setcellpush" sender:self];
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
