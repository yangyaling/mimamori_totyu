//
//  SinarioController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SinarioController.h"
#import "NITPicker.h"
#import "SinarioTableViewCell.h"

@interface SinarioController ()<MyPickerDelegate>


@property (strong, nonatomic) IBOutlet UITextField *sinarioText;

@property (strong, nonatomic) IBOutlet UIButton *sinariobutton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NITPicker       *picker;
@property (nonatomic, assign) NSInteger                    cellnum;

@property (nonatomic, strong) NSMutableArray                    *allarray;

@end

@implementation SinarioController

-(NSMutableArray *)allarray {
    if (!_allarray) {
        _allarray = [NSMutableArray new];
    }
    return _allarray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.cellnum = 1;
    
    self.sinariobutton.layer.cornerRadius = 6;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

/**
 PickerDelegate
 */
- (void)PickerDelegateSelectString:(NSString *)sinario withBool:(BOOL)addcell {
    if (addcell) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.allarray insertObject:sinario atIndex:0];
//        self.cellnum ++;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else {
        self.sinarioText.text = sinario;
    }
    
}

- (IBAction)PickShow:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _allarray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SinarioTableViewCell *cell = [SinarioTableViewCell cellWithTableView:tableView];
    
    [cell.sinarioButton setTitle:self.allarray[indexPath.row] forState:UIControlStateNormal];
    
    return cell;
    
}
//
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width,100)];
//    footerView.backgroundColor = [UIColor redColor];
    
    UIButton *editButton =[[UIButton alloc] initWithFrame:CGRectMake(20, 5, 40, 35)];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(62, 20, self.view.width - 82, 1.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *saveButton =[[UIButton alloc] initWithFrame:CGRectMake(self.view.width *0.2, 45, self.view.width - (self.view.width *0.4), 50)];
    
    
    [editButton setTitle: @"＋" forState: UIControlStateNormal];
    editButton.tag = 88;
    [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(addScenarioCell:) forControlEvents:UIControlEventTouchUpInside];
    
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:36.0];
    editButton.layer.cornerRadius = 5;
    editButton.layer.borderWidth = 1.3;
    editButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [saveButton setTitle: @"登 録" forState: UIControlStateNormal];
    saveButton.backgroundColor = NITColor(123, 182, 254);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveScenario:) forControlEvents:UIControlEventTouchUpInside];
    
    saveButton.titleLabel.font = [UIFont systemFontOfSize:26.0];
    saveButton.layer.cornerRadius = 5;
//    saveButton.layer.borderWidth = 1.3;
//    saveButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [footerView addSubview:editButton];
    [footerView addSubview:saveButton];
    [footerView addSubview:line];
    
    return footerView;
}


- (void)addScenarioCell:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
    
    
}

- (void)saveScenario:(UIButton *)sender {
    [MBProgressHUD showSuccess:@"Success"];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.allarray removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    } 
}




-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return  YES;
}

@end
