//
//  FirstViewController.h
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-15.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblWelcomeUsr;
@property (weak, nonatomic) IBOutlet UIImageView *defaultAppImg;

@property (weak, nonatomic) IBOutlet UILabel *fridgeFullLevelLbl;
@property (weak, nonatomic) IBOutlet UILabel *fridgeCapLbl;
@property (weak, nonatomic) IBOutlet UIProgressView *fridgeFullLevelBar;

@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated;

@end

