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
#import "LoadingView.h"
#import "ProdAPI.h"

@interface LockConfirmScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LockConfirmScreen
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_partsCountLabel;
    __weak IBOutlet UILabel *_bomLabel;
    
    NSMutableArray *_chosenQuantities;
    NSMutableArray *_parts;
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
    
    if ([self completedCount] < _parts.count) {
        [LoadingView showShortMessage:@"Please allocate all parts!"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to start this run?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callLockAPI];
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:true completion:nil];
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
    
    PartModel *p = [self partAtIndex:indexPath];
    int all = [_chosenQuantities[indexPath.section][indexPath.row] intValue];
    [cell layoutWithPart:p allocated:all];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    PartModel *p = [self partAtIndex:indexPath];
    int stock = [p totalStock];
    if (stock <= 0) {
        [LoadingView showShortMessage:@"Empty stock!"];
    } else {
        
        
        int current = [_chosenQuantities[indexPath.section][indexPath.row] intValue];
        PartModel *main = _parts[indexPath.section];
        int maxPossible = main.shortQty - [self allocatedQTYAtIndex:(int)indexPath.section] + current;
        if (maxPossible > stock)
            maxPossible = stock;
        
        NSString *m = [NSString stringWithFormat:@"Maximum allocation value is %d", maxPossible];
        NSString *t = [NSString stringWithFormat:@"Insert quantity for\n%@: %@", (p.alternateParts.count == 0)?@"Alt.":@"Main", p.part];
        UIAlertController *c = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:UIAlertControllerStyleAlert];
        [c addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            if (current > 0)
                textField.text = [NSString stringWithFormat:@"%d", current];
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            int v = [[[[c textFields] firstObject] text] intValue];
            if (v > maxPossible) {
                [LoadingView showShortMessage:@"Value is too big"];
            } else if (v < 0) {
                [LoadingView showShortMessage:@"Invalid value"];
            } else {
                
                NSMutableArray *arr = _chosenQuantities[indexPath.section];
                [arr replaceObjectAtIndex:indexPath.row withObject:@(v)];
                [_chosenQuantities replaceObjectAtIndex:indexPath.section withObject:arr];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                [self layoutBOM];
                [self layoutCompletedCount];
            }
        }];
        [c addAction:confirm];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [c addAction:cancel];
        [self presentViewController:c animated:true completion:nil];
    }
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
        PartModel *p = _parts[i];
        price += [self priceAtIndex:i]*[p.qty floatValue];
    }
    
    _bomLabel.text = [NSString stringWithFormat:@"%.4f$", price];
}

- (void) layoutCompletedCount {
    
    int c = [self completedCount];
    _partsCountLabel.text = [NSString stringWithFormat:@"%d/%lu", c, _parts.count];
    _partsCountLabel.textColor = (c == _parts.count) ? ccolor(67, 194, 81) : ccolor(233, 46, 40);
}

- (int) completedCount {
    
    int c = 0;
    for (int i=0; i<_parts.count; i++) {
        
        PartModel *p = _parts[i];
        if (p.alternateParts.count == 0 || [self allocatedQTYAtIndex:i] == p.shortQty || [p.package isEqualToString:@"yes"])
            c++;
    }
    return c;
}

#pragma mark - Utils

- (PartModel*) partAtIndex:(NSIndexPath*)index {
    
    PartModel *main = _parts[index.section];
    PartModel *p = index.row == 0 ? main : main.alternateParts[index.row-1];
    return p;
}

- (void) prepareData {
    
    [self prepareParts];
    
    _chosenQuantities = [NSMutableArray array];
    for (int i=0; i<_parts.count; i++) {
        
        PartModel *p = _parts[i];
        if (p.alternateParts.count > 0) {
            
            NSMutableArray *arr = [NSMutableArray array];
            if ([p.package isEqualToString:@"yes"])
                [arr addObject:@(p.shortQty)];
            else
                [arr addObject:@(0)];
            for (int j=0;j<p.alternateParts.count;j++)
                [arr addObject:@(0)];
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
                    totalPartPrice += q*altPrice;
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

- (void) prepareParts {
 
    int noOfRedParts = 0;
    _parts = [NSMutableArray array];
    
    for (int i=0; i<_runParts.count; i++) {
        
        PartModel *p = _runParts[i];
        if (p.alternateParts.count == 0 || [p.package isEqualToString:@"yes"]) {
            [_parts addObject:p];
        } else {
            [_parts insertObject:p atIndex:noOfRedParts];
            noOfRedParts++;
        }
    }
}

- (NSString*) generateJSON {
    
    NSMutableArray *data = [NSMutableArray array];
    for (int i=0; i<_parts.count; i++) {
        
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        
        PartModel *main = _parts[i];
        d[@"partName"] = main.part;
        
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *chosenQuantities = _chosenQuantities[i];
        for (int j=0; j<chosenQuantities.count; j++) {
            
            if ([chosenQuantities[j] intValue] > 0) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"qty"] = chosenQuantities[j];
                if (j == 0) {
                    dict[@"name"] = main.part;
                    dict[@"type"] = @"main";
                    dict[@"pricePerUnit"] = [NSString stringWithFormat:@"%.4f", [main.pricePerUnit floatValue]];
                } else {
                    PartModel *p = main.alternateParts[j-1];
                    dict[@"name"] = p.part;
                    dict[@"type"] = @"alternate";
                    float altPrice = [p.priceHistory[0][@"PRICE"] floatValue];
                    dict[@"pricePerUnit"] = [NSString stringWithFormat:@"%.4f", altPrice];
                }
                [arr addObject:dict];
            }
        }
        d[@"parts"] = arr;
        [data addObject:d];
    }
    
    NSString *json = [ProdAPI jsonString:data];
    return json;
}

- (void) callLockAPI {
 
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] lockRun:(int)_run.runId withAllocations:[self generateJSON] completion:^(BOOL success, id response) {

        if (success) {
            [LoadingView removeLoading];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RUNWASLOCKED" object:nil];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

@end
