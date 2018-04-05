//
//  AppDelegate.h
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-15.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonnull) NSString *userNameStr;
@property (strong, nonnull) NSDictionary *resultDict;
@property (strong, nonnull) NSDictionary *shelfDict;
@property (strong, nonnull) NSDictionary *withinShelfDict;
@property (strong, nonnull) NSString *lastUpdateStr;
@property (strong, nonnull) NSString *fridgeImgStr;
@property (strong, nonnull) NSString *capValStr;


@end

