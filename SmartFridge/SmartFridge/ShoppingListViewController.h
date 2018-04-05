//
//  ShoppingListViewController.h
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-02-09.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listView;


@end
