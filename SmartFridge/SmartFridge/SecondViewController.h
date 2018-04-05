//
//  SecondViewController.h
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-15.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *fridgeImg;
@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

