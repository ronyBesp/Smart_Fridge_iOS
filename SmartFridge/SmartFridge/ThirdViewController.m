//
//  ThirdViewController.m
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-16.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import "ThirdViewController.h"
#import "AppDelegate.h"
@interface ThirdViewController ()
{
    NSMutableArray *fridgeItemsArry;
}
@end

@implementation ThirdViewController
@synthesize listView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndUpdateTable) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    // We need to get the resultDict and analyze it
    [self loadAndUpdateTable];
}

- (void) loadAndUpdateTable {
    fridgeItemsArry = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@", delegate.resultDict);
    NSString *resStr = [NSString stringWithFormat:@"%@", delegate.resultDict];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"u'" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *formatArry = [resStr componentsSeparatedByString:@", "];
    
    NSArray *tempSplitCmps = [[NSArray alloc] init];
    NSString *objectStr = [[NSString alloc] init];
    for (int i = 0; i < [formatArry count]; i++) {
        tempSplitCmps = [formatArry[i] componentsSeparatedByString:@":"];
        // Remove whitespace - formatting cleaner
        // Always working with index 1 cuz index 0 is the key so 0, 1, ..
        objectStr = [tempSplitCmps[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
        // Before we add the item to the array we need to make sure that its not empty and also if there are more than one
        // ie. apple, lime comma seperated then we split em
        
        if (![objectStr isEqualToString:@""]) {
            if ([objectStr containsString:@","]) {
                NSArray *multiObjArry = [objectStr componentsSeparatedByString:@","];
                // Add all of the objects in the original string to the fridge array
                for (int i = 0; i < [multiObjArry count]; i++) {
                    [fridgeItemsArry addObject:multiObjArry[i]];
                }
            }
            else {
                [fridgeItemsArry addObject:objectStr];
            }
        }
    }
    NSOrderedSet *noDupSet = [NSOrderedSet orderedSetWithArray:fridgeItemsArry];
    fridgeItemsArry = [[NSMutableArray alloc] initWithArray:[noDupSet array] copyItems:YES];
    [listView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fridgeItemsArry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Item List";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = [fridgeItemsArry objectAtIndex:indexPath.row];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
