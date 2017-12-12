//
//  LockConfirmScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LockConfirmScreen.h"
#import "PartModel.h"
#import "LockConfirmationHeaderView.h"
#import "LockConfirmationCell.h"
#import "Defines.h"

@interface LockConfirmScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LockConfirmScreen
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_partsCountLabel;
    __weak IBOutlet UILabel *_bomLabel;
    
    NSMutableArray *_chosenQuantities;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self prepareData];
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
     [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction) saveButtonTapped {
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _parts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PartModel *p = _parts[section];
    if (p.alternateParts.count == 0) {
        return 0;
    } else {
        return 1 + p.alternateParts.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [LockConfirmationHeaderView height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LockConfirmationHeaderView *h = [LockConfirmationHeaderView createView];
    int t = [self allocatedQTYAtIndex:(int)section];
    float p = [self priceAtIndex:(int)section];
    [h layoutWithPart:_parts[section] atIndex:(int)section allocated:t price:p];
    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"LockConfirmationCell";
    LockConfirmationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    PartModel *main = _parts[indexPath.section];
    PartModel *p = indexPath.row == 0 ? main : main.alternateParts[indexPath.row-1];
    int all = [_chosenQuantities[indexPath.section][indexPath.row] intValue];
    [cell layoutWithPart:p allocated:all];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Layout

- (void) initLayout {
    
    self.title = @"";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self layoutCompletedCount];
    [self layoutBOM];
}

- (void) layoutBOM {
 
    float price = 0;
    
    for (int i=0; i<_parts.count; i++) {
        price += [self priceAtIndex:i];
    }
    
    _bomLabel.text = [NSString stringWithFormat:@"%.4f$", price];
}

- (void) layoutCompletedCount {
    
    int c = 0;
    for (int i=0; i<_parts.count; i++) {
        
        PartModel *p = _parts[i];
        if (p.alternateParts.count == 0 || [self allocatedQTYAtIndex:i] == p.shortQty)
            c++;
    }
    
    _partsCountLabel.text = [NSString stringWithFormat:@"%d/%lu", c, _parts.count];
    _partsCountLabel.textColor = (c == _parts.count) ? ccolor(67, 194, 81) : ccolor(233, 46, 40);
}

#pragma mark - Utils

- (void) prepareData {
    
    _chosenQuantities = [NSMutableArray array];
    for (int i=0; i<_parts.count; i++) {
        
        PartModel *p = _parts[i];
        if (p.alternateParts.count > 0) {
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@(0)];
            for (PartModel *a in p.alternateParts) {
                [arr addObject:@(0)];
            }
            [_chosenQuantities addObject:arr];
        } else {
            [_chosenQuantities addObject:@[@(p.shortQty)]];
        }
    }
}

- (int) allocatedQTYAtIndex:(int)i {
    
    NSArray *chosenQuantities = _chosenQuantities[i];
    int t = 0;
    for (NSNumber *n in chosenQuantities) {
        t += [n intValue];
    }
    return t;
}

- (float) priceAtIndex:(int)i {
    
    PartModel *p = _parts[i];
    if (p.alternateParts.count == 0) {
        return [p.pricePerUnit floatValue];
    } else {
        
        NSArray *chosenQuantities = _chosenQuantities[i];
        float totalPartPrice = 0;
        int totalQty = 0;
        for (int j=0; j<chosenQuantities.count; j++) {
            int q = [chosenQuantities[j] intValue];
            totalQty += q;
            if (j==0)
                totalPartPrice += totalPartPrice + q*[p.pricePerUnit floatValue];
            else {
                PartModel *alternate = p.alternateParts[j-1];
                if (alternate.priceHistory.count > 0) {
                    float altPrice = [alternate.priceHistory[0][@"PRICE"] floatValue];
                    totalPartPrice += totalPartPrice + q*altPrice;
                }
            }
        }
        
        if (totalQty != 0) {
            float finalPrice = totalPartPrice/totalQty;
            return finalPrice;
        } else {
            return 0;
        }
    }
}

@end
