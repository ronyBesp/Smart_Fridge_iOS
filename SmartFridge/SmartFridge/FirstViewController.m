//
//  FirstViewController.m
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-15.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize lblWelcomeUsr, defaultAppImg, fridgeFullLevelLbl, fridgeFullLevelBar, lblLastUpdated, fridgeCapLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateServerResultsAndApp) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void) viewWillAppear:(BOOL)animated {
    [self updateServerResultsAndApp];
}

- (void) updateServerResultsAndApp {
    // Done before the view actually shows to user
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // show the welcome msg to user
    NSString *welcomeMsg = [NSString stringWithFormat:@"Welcome, %@", delegate.userNameStr];
    lblWelcomeUsr.text = welcomeMsg;
    
    // Now we want to call method to retrieve latest result for a user from the server
    [self getLatestResultFromServer];
    NSLog(@"Delegate values");
    NSLog(@"Last Update: %@", delegate.lastUpdateStr);
    NSLog(@"Result Dict: %@", delegate.resultDict);
    NSLog(@"Img Link is: %@", delegate.fridgeImgStr);
    NSLog(@"Shelf Dict: %@", delegate.shelfDict);
    NSLog(@"Within Shelf Dict: %@", delegate.withinShelfDict);
    NSLog(@"Capacity Value is %@", delegate.capValStr);
    // Truncate value
    int capVal = [delegate.capValStr intValue];
    NSLog(@"Cap: %d", capVal);
    
    NSString *capMsg = [NSString stringWithFormat:@"%d%%", capVal];
    fridgeCapLbl.text = capMsg;
    //fridgeFullLevelBar.progress = 40.0;
    //[fridgeFullLevelBar setProgress:40.0 animated:YES];
    
    NSString *lastUpdateDate = [[NSString alloc] initWithFormat:@"%@", delegate.lastUpdateStr];
    // Need to parse the date
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    //[dtFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dtFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ"];
    NSDate *decomposedDateStr = [dtFormat dateFromString:lastUpdateDate];
    NSLog(@"Last Update: %@", decomposedDateStr);
    
    NSString *userDayDisplay = [[NSString alloc] init];
    NSDate *curDate = [NSDate date];
    NSLog(@"%@", curDate);
    
    // We need to set the time of the server date to 00:00 all the time for the dayDiff comparisions to accurately work as measuring second difference between the two dates
    NSCalendar *curCal = [NSCalendar currentCalendar];
    NSUInteger dateVals = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone);
    NSDateComponents *dateComps = [curCal components:dateVals fromDate:decomposedDateStr];
    [dateComps setHour: 0];
    [dateComps setMinute:00];
    [dateComps setSecond:00];
    NSDate *strippedServerDate = [curCal dateFromComponents:dateComps];
    
    NSTimeInterval dateDiffs = [curDate timeIntervalSinceDate:strippedServerDate];
    int dayDiff = dateDiffs / (60*60*24);
    NSLog(@"%d", dayDiff);
    
    // Get the hour & min info from the correct original server date - stripped server date only used for figuring day differences
    dateVals = (NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute);
    dateComps = [curCal components:dateVals fromDate:decomposedDateStr];
    
    // Account for minute if < 10 -> need to add 0 to it in text output
    NSString *minuteStr = [[NSString alloc] init];
    if ([dateComps minute] < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld", (long)[dateComps minute]];
    }
    else
    {
        minuteStr = [NSString stringWithFormat:@"%ld", (long)[dateComps minute]];
    }
    if (dayDiff == 0) {
        userDayDisplay = [NSString stringWithFormat:@"Today at %ld:%@", (long)[dateComps hour], minuteStr];
    }
    else if (dayDiff == 1) {
        // Yesterday cuz current date is being compared to server date so if 1 then means current date is 1 day > server date
        userDayDisplay = [NSString stringWithFormat:@"Yesterday at %ld:%@", (long)[dateComps hour], minuteStr];
    }
    else
    {
        // Difference > 1 day - just show the day itself
        // Day 1 is sunday
        NSArray *dayArry = [[NSArray alloc] initWithObjects:@"", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
        NSLog(@"%@", dayArry[[dateComps weekday]]);
        userDayDisplay = [NSString stringWithFormat:@"%@ at %ld:%@", dayArry[[dateComps weekday]], [dateComps hour], minuteStr];
    }
    
    // Show the last update day to the user
    lblLastUpdated.text = userDayDisplay;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getLatestResultFromServer {
    // We will save the results to the app delegate therefore we only have to do one GET to server and not on every tab
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
        NSLog(@"%@", jsonResponse[0]);
        delegate.lastUpdateStr = jsonResponse[0][@"last_updated"];
        delegate.resultDict = jsonResponse[0][@"resultDict"];
        delegate.shelfDict = jsonResponse[0][@"shelfImgPaths"];
        delegate.withinShelfDict = jsonResponse[0][@"withinShelfImgPaths"];
        delegate.fridgeImgStr = jsonResponse[0][@"img"];
        delegate.capValStr = jsonResponse[0][@"capacity"];
        // Unlock semaphore
        dispatch_semaphore_signal(semaphore);
    }];
    [getDataTask resume];
    // Continue to wait
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

}


@end
