//
//  SensorController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SensorController.h"
#import "SensorSetTableViewCell.h"

#import "AddTableViewCell.h"

@interface SensorController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sensorSegment;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, assign) BOOL        isSensorTableView;

@property (nonatomic, assign) NSInteger addDataH;
@property (strong, nonatomic) IBOutlet UIButton *setPushButton;

@end

@implementation SensorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.saveButton.layer.cornerRadius = 6;
    
    self.setPushButton.layer.cornerRadius = 6;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
//    self.tableView.backgroundColor = [UIColor redColor];
    
    self.isSensorTableView = YES;
    self.addDataH = 0;
    
}
- (IBAction)selectAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0){
        self.isSensorTableView = YES;
        self.saveButton.hidden = NO;
        self.tableView.frame = CGRectMake(0, 141 , NITScreenW, NITScreenH - 250);
        self.addDataH = 0;
        
    } else {
        self.saveButton.hidden = YES;
        self.isSensorTableView = NO;
        self.tableView.frame = CGRectMake(0, 141 , NITScreenW, NITScreenH - 190);
        self.addDataH = 45;
    }
    
    [self.tableView reloadData];
    
}

- (IBAction)SaveSelectedData:(UIButton *)sender {
    
    [MBProgressHUD showSuccess:@"Success"];
    
}
- (IBAction)GoInSetVC:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"profilePush" sender:self];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSensorTableView) {
        return self.sensors.count;
    } else {
        return 1;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSensorTableView) {
        SensorSetTableViewCell *cell = [SensorSetTableViewCell cellWithTableView:tableView];
        
        cell.sensorname.text = self.sensors[indexPath.row];
        
        return cell;
    } else {
        AddTableViewCell *cell = [AddTableViewCell cellWithTableView:tableView];
        
        return cell;
    }
    
}
//
//自定义 SectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.tableView.width,45)];
//    titleView.backgroundColor = NITColor(235, 235, 235);
    
    //シナリオ
        
    UIButton *editButton =[[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width*0.85, 5, 40, 35)];
    [editButton setTitle: @"＋" forState: UIControlStateNormal];
    [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(addScenario:) forControlEvents:UIControlEventTouchUpInside];
    
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:36.0];
    editButton.layer.cornerRadius = 5;
    editButton.layer.borderWidth = 1.3;
    editButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [titleView addSubview:editButton];
    
    return titleView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.addDataH;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)addScenario:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"scenarioPush" sender:self];
}

@end
