//
//  TasklistView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "TasklistView.h"
#import "TasklistViewCell.h"
#import <Parse/Parse.h>
#import "UIImage+FontAwesome.h"


@implementation TasklistView
__CREATEVIEW(TasklistView, @"TasklistView", 0);

- (void)initView {
    UIImage *iconAdd = [UIImage imageWithIcon:@"fa-plus-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:15];
    [_addButton setImage:iconAdd forState:UIControlStateNormal];
    namesArray = [NSMutableArray arrayWithObjects:@"Matt", @"Ashok", @"Arvind", @"Ram", @"Elizabeth", @"Arthur", @"Vally",nil];
    [self getTasks];
    [_tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tasksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"TasklistViewCell";
    TasklistViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:[tasksArray objectAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // [_delegate runSelectedAtIndex:indexPath.row];
}

- (void)getTasks {
    PFQuery *query = [PFQuery queryWithClassName:@"TaskList"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        tasksArray = objects;
        [_tableView reloadData];
    }];
}

- (void)saveTaskDataInParse:(NSMutableDictionary*)taskData {
    PFObject *parseObject = [PFObject objectWithClassName:@"TaskList"];
    parseObject[@"AssignedBy"] = [taskData objectForKey:@"AssignedBy"];
    parseObject[@"AssignedTo"] = [taskData objectForKey:@"AssignedTo"];
    parseObject[@"DueDate"] = [taskData objectForKey:@"DueDate"];
    parseObject[@"Task"] = [taskData objectForKey:@"Task"];
    parseObject[@"Status"] = @"Open";
    NSLog(@"saving parse object = %@",parseObject);
    BOOL succeeded = [parseObject save];
    if (succeeded) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data Saved Successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        [self getTasks];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error in saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void) deleteTaskAtIndex:(int)index {
    PFObject *parseObj = tasksArray[index];
    [parseObj delete];
    [tasksArray removeObjectAtIndex:index];
    [_tableView reloadData];
}

- (void) updateStatus:(BOOL)value forIndex:(int)index {
    PFObject *parseObj = tasksArray[index];
    if (value) {
        parseObj[@"Status"] = @"Closed";
    }
    else {
        parseObj[@"Status"] = @"Open";
    }
    [parseObj save];
}

- (IBAction)addPressed:(id)sender {
    _addTaskView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addTaskView.layer.borderWidth = 1.0f;
    _addTaskView.frame = CGRectMake(self.frame.size.width/2-_addTaskView.frame.size.width/2, self.frame.size.height/2-_addTaskView.frame.size.height/2, _addTaskView.frame.size.width, _addTaskView.frame.size.height);
    [self addSubview:_addTaskView];
}

- (IBAction)cancelAddPressed:(id)sender {
    [_addTaskView removeFromSuperview];
    [_taskTextView resignFirstResponder];
}

- (IBAction)submitAddPressed:(id)sender {
    [_addTaskView removeFromSuperview];
    [_taskTextView resignFirstResponder];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_assignedByButton.titleLabel.text,@"AssignedBy", _assignedToButton.titleLabel.text, @"AssignedTo", _dueDateButton.titleLabel.text, @"DueDate", _taskTextView.text, @"Task", nil];
    
    [self saveTaskDataInParse:dictionary];
}

- (IBAction)showDropDownList:(UIButton*)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :namesArray :nil :@"down"];
        dropDown.tag = sender.tag;
        dropDown.backgroundColor = [UIColor grayColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {

    dropDown = nil;
}


- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

-(IBAction)pickDatePressed:(id)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    // calendar.tag = tag;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self addSubview:calendar];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    // dateItem.backgroundColor = [UIColor redColor];
    // dateItem.textColor = [UIColor whiteColor];
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return true;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    [_dueDateButton setTitle:dateString forState:UIControlStateNormal];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        //self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([_taskTextView.text isEqualToString:@"Add task here.."])
    {
        _taskTextView.text = @"";
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (!_taskTextView.text.length)
    {
        _taskTextView.text = @"Add task here..";
        _taskTextView.textColor = [UIColor grayColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_taskTextView resignFirstResponder];
        return false;
    }
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Add task here.." withString:@""];
    return true;
}


@end
