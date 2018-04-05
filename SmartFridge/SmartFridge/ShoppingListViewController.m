//
//  ShoppingListViewController.m
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-02-09.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "AppDelegate.h"

@interface ShoppingListViewController ()
{
    NSString *oldItemStr;
    NSMutableArray *diffItemArry;
}
@end

@implementation ShoppingListViewController
@synthesize listView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndUpdateTable) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadAndUpdateTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadAndUpdateTable {
    [self getShoppingList];
    [listView reloadData];
}

- (void) getShoppingList {
    // Current item list stored in delegate
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Get previous item list
    [self getPreviousItemListFromServer]; // stored in the oldItemStr
    NSLog(@"Current:");
    NSLog(@"%@", delegate.resultDict);
    NSLog(@"Previous:");
    NSLog(@"%@", oldItemStr);
    
    // Extract the items from the strings
    NSString *resultDict = [NSString stringWithFormat:@"%@", delegate.resultDict];
    NSArray *currentItems = [self extractItemsFromServerStr: resultDict];
    NSArray *previousItems = [self extractItemsFromServerStr:oldItemStr];
    NSOrderedSet *noDupSet = [NSOrderedSet orderedSetWithArray:previousItems];
    NSMutableArray *previousItemsNew = [[NSMutableArray alloc] initWithArray:[noDupSet array] copyItems:YES];
    // Now we can compare side by side
    diffItemArry = [[NSMutableArray alloc] init];
    // Remove duplicates from array
    noDupSet = [NSOrderedSet orderedSetWithArray:currentItems];
    NSArray *currentItemsNoDupArry = [noDupSet array];
    
    // Comparing previous to current - shopping list should have items previous had that current doesn't have
    for (int i = 0; i < [previousItemsNew count]; i++) {
        if (![currentItemsNoDupArry containsObject:previousItemsNew[i]]) {
            [diffItemArry addObject: previousItemsNew[i]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [diffItemArry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Shopping List";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = [diffItemArry objectAtIndex:indexPath.row];
    return cell;
}


- (NSArray *) extractItemsFromServerStr: (NSString *) serverStr {
    NSMutableArray *currentFridgeItems = [[NSMutableArray alloc] init];
    
    // Now we want to do the comparison
    NSString *resStr = [NSString stringWithFormat:@"%@", serverStr];
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
                    [currentFridgeItems addObject:multiObjArry[i]];
                }
            }
            else {
                [currentFridgeItems addObject:objectStr];
            }
        }
    }
    
    // Deep copy before return
    NSArray *currentFridgeItemsCpy = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:currentFridgeItems]];

    return currentFridgeItemsCpy;
}

- (void) getPreviousItemListFromServer {
    // Construct the GET request
    NSMutableURLRequest *requestGET = [[NSMutableURLRequest alloc] init];
    [requestGET setURL:[NSURL URLWithString:@"http://138.197.175.107/api/fridgecontents/?user=iosAcct"]];
    [requestGET setHTTPMethod:@"GET"];
    [requestGET setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestGET setTimeoutInterval:24];
    
    // Create semaphore to create a synchronous request
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:requestGET completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        // 0th element contains the most recent result
        NSLog(@"%@", jsonResponse[1]);
        oldItemStr = jsonResponse[1][@"resultDict"];
        
        // Unlock semaphore
        dispatch_semaphore_signal(semaphore);
    }];
    [getDataTask resume];
    // Continue to wait
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

@end
