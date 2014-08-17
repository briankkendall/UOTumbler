//
//  UserViewController.m
//  TumblrApplication
//
//  Created by bkendall on 8/12/14.
//  Copyright (c) 2014 bkendall. All rights reserved.
//

#import "UserViewController.h"
#import "TMAPIClient.h"
#import "UOFeedCollectionViewController.h"
//#import "JXHTTP.h"
#import "AFNetworkReachabilityManager.h"

@interface UserViewController ()

@end

@implementation UserViewController
@synthesize txtStringOrUsername, lblError;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    


}
- (void)viewWillAppear:(BOOL)animated{
    [lblError setHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnGoTapped:(id)sender {
  
    responseData = [[NSMutableData alloc] init];
    
    messages = [NSArray array];
    NSString *nameOrUrlString;
    NSArray *tmpArray = [txtStringOrUsername.text componentsSeparatedByString:@"."];
    if (tmpArray)
    {
        nameOrUrlString = [tmpArray objectAtIndex:0];
    }else{
        nameOrUrlString = [[[txtStringOrUsername.text stringByReplacingOccurrencesOfString:@"http" withString:@""] stringByReplacingOccurrencesOfString:@"//" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    }

    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
        [[TMAPIClient sharedInstance] blogInfo: [NSString stringWithFormat:@"%@.tumblr.com", nameOrUrlString]
                                      callback:^ (id result, NSError *error) {
                                          // ...
                                        
                                          if (!error) {
                                              NSLog(@"ok");
                                              //success
                                              responseDict = result;
                                              responseData = result;
                                              
                                              [self performSegueWithIdentifier:@"showFeed" sender:self];
                                              [lblError setHidden:YES];
                                          }else{
                                              //error
                                              [lblError setHidden: NO];
                                          }
                                      }];
    }

    

}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showFeed"])
    {
        // Get reference to the destination view controller
        UOFeedCollectionViewController *vc = [segue destinationViewController];
        // Pass any objects to the view controller here, like...
        [vc setResponseDict:responseDict];

    }
}
@end
