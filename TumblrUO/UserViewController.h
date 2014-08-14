//
//  UserViewController.h
//  TumblrApplication
//
//  Created by bkendall on 8/12/14.
//  Copyright (c) 2014 bkendall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
{
    NSMutableData *responseData;
    NSArray *messages;
    NSDictionary *responseDict;
}
@property (weak, nonatomic) IBOutlet UITextField *txtStringOrUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblError;

@end
