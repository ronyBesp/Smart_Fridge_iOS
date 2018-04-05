//
//  ThirdViewController.h
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-16.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listView;

@end
