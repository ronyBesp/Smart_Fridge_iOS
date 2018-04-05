//
//  SecondViewController.m
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-15.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
@interface SecondViewController ()
{
    NSMutableArray *fridgePathArry;
    NSMutableArray *fridgeDisplayArry;
    NSString *navigationPath;
}

@end

@implementation SecondViewController
@synthesize fridgeImg, listView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndUpdateTable) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    // Load in the table view
    [self loadAndUpdateTable];
}

- (void) loadAndUpdateTable {
    // First index should always be the original Image
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    fridgeDisplayArry = [[NSMutableArray alloc] init];
    fridgePathArry = [[NSMutableArray alloc] init];

    [fridgeDisplayArry addObject:@"Original Image"];
    [fridgeDisplayArry addObject:@"By Shelf"];
    [fridgeDisplayArry addObject:@"By Item"];
    [fridgePathArry addObject:delegate.fridgeImgStr];
    navigationPath = [NSString stringWithFormat:@"Start"];
    
    [listView setHidden: NO];
    [listView reloadData];
}

- (IBAction)backButton:(id)sender {
    [self loadAndUpdateTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fridgeDisplayArry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Fridge View";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = [fridgeDisplayArry objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction) backSequence: (id) sender {
    [self loadAndUpdateTable];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
    // Conditions
    if ([navigationPath isEqualToString:@"Start"]) {
        if ([fridgeDisplayArry[indexPath.row] isEqualToString:@"Original Image"]) {
            UIImage *retrievedImg = [self downloadFridgeImg: fridgePathArry[indexPath.row]];
            [fridgeImg setImage:retrievedImg];
            [listView setHidden: YES];
            [fridgeImg setHidden: NO];
        }
        else if ([fridgeDisplayArry[indexPath.row] isEqualToString:@"By Shelf"]) {
            // get the shelf contents
            fridgePathArry = [self getShelfImgArry];
            // Now we need to get the count of shelfs for the display arry
            fridgeDisplayArry = [[NSMutableArray alloc] init];
            for (int i = 1; i <= [fridgePathArry count]; i++) {
                NSString *formatStr = [NSString stringWithFormat:@"Shelf %d", i];
                [fridgeDisplayArry addObject:formatStr];
            }
            // Now go ahead and update the table view
            // Update navigation path
            navigationPath = [NSString stringWithFormat:@"Shelf"];
            [listView reloadData];
        }
        else {
            // Must be by item
            // Display the shelf count
            fridgePathArry = [self getShelfImgArry];
            // Now we need to get the count of shelfs for the display arry
            fridgeDisplayArry = [[NSMutableArray alloc] init];
            for (int i = 1; i <= [fridgePathArry count]; i++) {
                NSString *formatStr = [NSString stringWithFormat:@"Shelf %d", i];
                [fridgeDisplayArry addObject:formatStr];
            }
            // Now go ahead and update the table view
            // Update navigation path
            navigationPath = [NSString stringWithFormat:@"Item Initial"];
            [listView reloadData];
        }
    }
    else if ([navigationPath isEqualToString:@"Shelf"]) {
        // We want to display the shelf image at the index
        UIImage *retrievedImg = [self downloadFridgeImg: fridgePathArry[indexPath.row]];
        [fridgeImg setImage:retrievedImg];
        [listView setHidden: YES];
        [fridgeImg setHidden: NO];
    }
    else if ([navigationPath isEqualToString:@"Item Initial"]){
        // Must be item
        // Right now we see the shelfs ie. Shelf 1, 2, 3
        // So indexPath.row contains shelf num
        // We want to go ahead and get all the items within the specified shelf
        NSString *shelfNumStr = [NSString stringWithFormat:@"%ld", indexPath.row];
        fridgePathArry = [self getWithinShelfImgArry: shelfNumStr];
        
        // Now we need to get the count of items for the display arry
        fridgeDisplayArry = [[NSMutableArray alloc] init];
        for (int i = 1; i <= [fridgePathArry count]; i++) {
            NSString *formatStr = [NSString stringWithFormat:@"Item %d", i];
            [fridgeDisplayArry addObject:formatStr];
        }
        // Now go ahead and update the table view
        // Update navigation path
        navigationPath = [NSString stringWithFormat:@"Item Final"];
        [listView reloadData];
    }
    else {
        // Show the item they chose
        // We want to display the item image at the index
        UIImage *retrievedImg = [self downloadFridgeImg: fridgePathArry[indexPath.row]];
        [fridgeImg setImage:retrievedImg];
        [listView setHidden: YES];
        [fridgeImg setHidden: NO];
    }
}

- (void) updateImageView {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIImage *retrievedImg = [self downloadFridgeImg: delegate.fridgeImgStr];
    [fridgeImg setImage:retrievedImg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *) downloadFridgeImg : (NSString *) urlPath{
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlPath]];
    UIImage *retImg = [UIImage imageWithData:imgData];
    return retImg;
}

- (NSMutableArray *) getShelfImgArry {
    NSMutableArray *shelfImgArry = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@", delegate.shelfDict);
    NSString *resStr = [NSString stringWithFormat:@"%@", delegate.shelfDict];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"u'" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *formatArry = [resStr componentsSeparatedByString:@", "];
    
    NSArray *tempSplitCmps = [[NSArray alloc] init];
    int addVal = 0;
    while (addVal != [formatArry count]) {
        for (int i = 0; i < [formatArry count]; i++) {
            // 0: http://..
            tempSplitCmps = [formatArry[i] componentsSeparatedByString:@": "];
            if (addVal == [tempSplitCmps[0] intValue]) {
                [shelfImgArry addObject:tempSplitCmps[1]];
                addVal++;
                // Only 1 shelf with the number so once detected can break and go ouf of for
                break;
            }
        }
    }
    
    return shelfImgArry;
}

- (NSMutableArray *) getWithinShelfImgArry: (NSString *) shelfNumStr {
    NSMutableArray *withinShelfImgArry = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@", delegate.withinShelfDict);
    NSString *resStr = [NSString stringWithFormat:@"%@", delegate.withinShelfDict];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"u'" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    resStr = [resStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *formatArry = [resStr componentsSeparatedByString:@", "];
    
    NSArray *tempSplitCmps = [[NSArray alloc] init];
    for (int i = 0; i < [formatArry count]; i++) {
        // 0: http://..
        tempSplitCmps = [formatArry[i] componentsSeparatedByString:@": "];
        // index 0 contains the shelf num ie. 0 is shelf 1
        // only get the shelfs that correspond to the shelf parameter num we want
        if ([tempSplitCmps[0] isEqualToString:shelfNumStr])
        {
            if (![tempSplitCmps[1] isEqualToString:@""]) {
                if ([tempSplitCmps[1] containsString:@","]) {
                    NSArray *multiImgPathArrayPerShelf = [tempSplitCmps[1] componentsSeparatedByString:@","];
                    for (int i = 0; i < [multiImgPathArrayPerShelf count]; i++) {
                        if (![multiImgPathArrayPerShelf[i] isEqualToString:@""]) {
                            [withinShelfImgArry addObject:multiImgPathArrayPerShelf[i]];
                        }
                    }
                }
                else {
                    // Just one image
                    [withinShelfImgArry addObject:tempSplitCmps[1]];
                }
            }
        }
    }
    return withinShelfImgArry;
}

@end
