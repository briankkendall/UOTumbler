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
//#import "SBJson4.h"

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
    [TMAPIClient sharedInstance].OAuthConsumerKey = @"AWsfhrXeaMwPHv9z0QYrgIG9A5UmYecvYVFI4LvHGJURP1PaoE";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"VvACSYBQojXWRgJBFNdzl7Xahe4q2zc1QmLbrwsgcbNjlX2Tgs";

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
  
    NSString *strOConsumerKey = @"AWsfhrXeaMwPHv9z0QYrgIG9A5UmYecvYVFI4LvHGJURP1PaoE";
    //NSString *strOConsumerSecretKey = @"VvACSYBQojXWRgJBFNdzl7Xahe4q2zc1QmLbrwsgcbNjlX2Tgs";
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
    //NSURL* url = [NSURL URLWithString:nameOrUrlString];
    nameOrUrlString = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/info?api_key=%@", nameOrUrlString, strOConsumerKey];

    
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:nameOrUrlString]];
    
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark NSURLConnection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //label.text = [NSString stringWithFormat:@"Connection Failed!"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSUTF8StringEncoding error:nil];
    if (responseDict) {
        NSDictionary *meta = [responseDict objectForKey:@"meta"];
        if ([[meta objectForKey:@"status"] integerValue] == 200) {
            NSLog(@"ok");
            //success
            [self performSegueWithIdentifier:@"showFeed" sender:self];
            [lblError setHidden:YES];
        }else{
            //error
            [lblError setHidden: NO];
        }
    }
}
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
