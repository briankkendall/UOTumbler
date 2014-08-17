//
//  UOFeedCollectionViewController.m
//  TumblrUO
//
//  Created by bkendall on 8/13/14.
//  Copyright (c) 2014 bkendall. All rights reserved.
//

#import "UOFeedCollectionViewController.h"
#import "Cell.h"
#import "UserViewController.h"
#import "TMAPIClient.h"
#import "AFNetworkReachabilityManager.h"

#define ITEMS_PAGE_SIZE 20
#define ITEM_CELL_IDENTIFIER @"UOTumblrCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"
#define STR_O_CONSUMER_KEY  @"AWsfhrXeaMwPHv9z0QYrgIG9A5UmYecvYVFI4LvHGJURP1PaoE";
@interface UOFeedCollectionViewController ()

@end

@implementation UOFeedCollectionViewController
@synthesize avatarImage;
@synthesize lblUsername, lblDescription, txtDescription;
@synthesize theCollectionView;
@synthesize customCollectionViewCell;
@synthesize lblCellLabel;
- (void)setResponseDict:(NSDictionary *)responseDictionary{
    responseDict = responseDictionary;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{

    
    responseData = [[NSMutableData alloc] init];
    messages = [NSMutableArray array];
    NSString *nameOrUrlString = [[responseDict objectForKey:@"blog"] objectForKey:@"name"];
    
    //set the username and the description
    lblUsername.text = [[responseDict objectForKey:@"blog"] objectForKey:@"name"];
    
    //might be html so this is attributed text
    [lblDescription setFont:[UIFont fontWithName:@"System" size:13]];
    lblDescription.attributedText = [self attributedStringWithHTML:[self styledHTMLwithHTML: [[responseDict objectForKey:@"blog"] objectForKey:@"description"]]];
    txtDescription.backgroundColor = [UIColor clearColor];
    txtDescription.attributedText = [self attributedStringWithHTML:[self styledHTMLwithHTML: [[responseDict objectForKey:@"blog"] objectForKey:@"description"]]];
    nameOrUrlString = [nameOrUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    nameOrUrlString = [nameOrUrlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    __block UIImage * image;
    if ([AFNetworkReachabilityManager sharedManager].reachable) {

        //set the avatar image
        [[TMAPIClient sharedInstance] avatar:[NSString stringWithFormat: @"%@.tumblr.com", nameOrUrlString]
                                            size:64
                                        callback:^ (id result, NSError *error) {
                                            // ...
                                            if (!error) {
                                                //strImagePath = result;
                                                image = [UIImage imageWithData:result];
                                                avatarImage.image = image;
                                            }else{
                                                NSLog(@"error");
                                            }
        }];
    }
    
//    //retrieve the posts
    [self getMoreData];


    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.theCollectionView registerClass:[Cell class] forCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER];
    [self.theCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    _currentPage = 0;
    _numRetrieved = 0;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    
    [self.theCollectionView addSubview:refreshControl];
    
}
- (void)reachabilityChanged:(NSNotification *)notice
{
    //not acting right
//    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
//    
//    if(remoteHostStatus == NotReachable) {NSLog(@"no");}
//    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMoreData {
    
    // Generate the 'next page' of data.
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
//
//        [[TMAPIClient sharedInstance] dashboard:@{@"type" : @"photo",
//                                                 @"type" : @"text",
//                                                 @"offset" : [NSNumber numberWithInteger: _currentPage * ITEMS_PAGE_SIZE]
//                                    
//                                                 } callback:^(id result, NSError *error){
//            if (!error) {
//                if ([messages count] > 0) {
//                    // Add the new data to our local collection of data.
//                    for (int i = 0; i < [[result objectForKey:@"posts"] count]; i++) {
//                        [messages addObject: [[result objectForKey:@"posts"] objectAtIndex:i]];
//                    }
//                }else{
//                    messages = [NSMutableArray arrayWithArray:[result objectForKey:@"posts"]];
//                }
//                _numRetrieved += ITEMS_PAGE_SIZE;
//                [theCollectionView reloadData];
//                
//            }
//        }];


        //retrieve the posts
        //increment the current page


        NSNumber *numItems = [NSNumber numberWithInteger: _currentPage * ITEMS_PAGE_SIZE];
            [[TMAPIClient sharedInstance] posts:[NSString stringWithFormat:@"%@.tumblr.com", lblUsername.text] type:nil parameters:@{ @"offset" : numItems  } callback:^(id result, NSError *error){
                
                if(!error)
                {
                    
                    if ([messages count] > 0) {
                        // Add the new data to our local collection of data.
                        for (int i = 0; i < [[result objectForKey:@"posts"] count]; i++) {
                            [messages addObject: [[result objectForKey:@"posts"] objectAtIndex:i]];
                        }
                    }else{
                        messages = [NSMutableArray arrayWithArray:[result objectForKey:@"posts"]];
                    }
                    _currentPage++;
                    _numRetrieved += ITEMS_PAGE_SIZE;
                    [theCollectionView reloadData];
                }
                
            }];
        }

}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    
    Cell *cell = (Cell *)[self.theCollectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Update the custom cell with some text
    NSLog([NSString stringWithFormat:@"Fetched item: %d", indexPath.item]);
    NSString *sentence = [[messages objectAtIndex:indexPath.row] objectForKey:@"caption"];
    NSString *word = @"Submitted By:";
    if ([sentence rangeOfString:word].location != NSNotFound && sentence != nil) {
        
        //Comments are html so make an attributed string to make it look right...
        NSString *tmpString = [self styledHTMLwithHTML:[[messages objectAtIndex:indexPath.row] objectForKey:@"caption"]];
        
        NSAttributedString *attributedText = [self attributedStringWithHTML:tmpString];
        cell.titleLabel.attributedText = attributedText;
    }else{

        cell.titleLabel.text = [[messages objectAtIndex:indexPath.row] objectForKey:@"blog_name"];
    }
    //enable tap event on the label
    [cell.titleLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
    gestureRec.numberOfTouchesRequired = 1;
    gestureRec.numberOfTapsRequired = 1;
    [cell.titleLabel addGestureRecognizer:gestureRec];
    
    
    cell.backgroundColor = [UIColor whiteColor];
    [cell.cellImage setHidden: YES];
    [cell.cellText setHidden: YES];
    if ([[[messages objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"text"]) {
        NSString *tmpString = [self styledHTMLwithHTML:[[messages objectAtIndex:indexPath.row] objectForKey:@"body"]];
        
        NSAttributedString *attributedText = [self attributedStringWithHTML:tmpString];
        cell.cellText.attributedText = attributedText;
        [cell.cellText setHidden: NO];
    }else if( [[[messages objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"link"]){
        NSString *tmpString = [self styledHTMLwithHTML:[[messages objectAtIndex:indexPath.row] objectForKey:@"url"]];
        
        NSAttributedString *attributedText = [self attributedStringWithHTML:tmpString];
        cell.cellText.attributedText = attributedText;
        [cell.cellText setHidden: NO];
    }else{
        NSDictionary *tmpDict = [[[messages objectAtIndex:indexPath.row] objectForKey:@"photos"] objectAtIndex:0];
        NSURL * imageURL = [NSURL URLWithString: [[tmpDict objectForKey:@"original_size"] objectForKey:@"url"]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(5,5, 320, 300)];
        imv.image=[UIImage imageWithData:imageData];
        cell.cellImage.image = [UIImage imageWithData:imageData];
//        [cell addSubview:imv];
        [cell.cellImage setHidden: NO];
    }
    [cell setNeedsDisplay];
    return cell;
}
- (NSString *)styledHTMLwithHTML:(NSString *)HTML {
    NSString *style = @"<meta charset=\"UTF-8\"><style> body { font-family: 'HelveticaNeue'; font-size: 20px; } b {font-family: 'MarkerFelt-Wide'; }</style>";
    
    return [NSString stringWithFormat:@"%@%@", style, HTML];
}

- (NSAttributedString *)attributedStringWithHTML:(NSString *)HTML {
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType };
    return [[NSAttributedString alloc] initWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL error:NULL];
}
-(void)startRefresh:(id)sender
{
    UIRefreshControl *tmpRefresh = (UIRefreshControl *)sender;
    _currentPage = 0;
    _numRetrieved = 0;
    [self getMoreData];
    [tmpRefresh endRefreshing];

}

-(void)labelTap:(UITapGestureRecognizer *)tgr{
    
    UILabel *tmpLabel = ((UILabel *)tgr.view);
    NSLog(@"tapped label: %@", tmpLabel.text);
    _selectedBlogUsername = tmpLabel.text;
    _selectedBlogUsername = @"nba";

        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            
            //hardcoded nba to make sure to navigate to another page.  Couldn't find where the api was returning the username of the other user other than the submitted: 'username' text.
            [[TMAPIClient sharedInstance] blogInfo: [NSString stringWithFormat:@"%@.tumblr.com", @"nba"]
                                          callback:^ (id result, NSError *error) {
                                              // ...
                                              
                                              if (!error) {
                                                  NSLog(@"ok");
                                                  //success
                                                  
                                                  UOFeedCollectionViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"UOFeedCollectionViewController"];
                                                  [newView setResponseDict:result];
                                                  
                                                  //old school way of doing a transition animation.  couldn't get custom transition stuff working with delegates
                                                  //TODO: keep playing with the delegates to get it to work the new way. 
                                                  [UIView animateWithDuration:0.75 animations:^{
                                                      [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                                      [self.navigationController pushViewController:newView animated:NO];
                                                      [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
                                                  } completion:nil];
                                                  //[self.navigationController pushViewController:newView animated:YES];
                                                  
                                                  responseDict = result;
                                                  responseData = result;
                                                  
                                                 // [self performSegueWithIdentifier:@"showFeed" sender:self];
                                                  //[lblError setHidden:YES];
                                              }else{
                                                  //error
                                                  //[lblError setHidden: NO];
                                              }
                                          }];
        }


    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showNextFeed"])
    {
        // Get reference to the destination view controller
        UserViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setUserNameText:_selectedBlogUsername];
    }
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Select item
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Cell *cell = (Cell *)[self.theCollectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    [UIView transitionWithView:theCollectionView
                      duration:.5
                       //options:UIViewAnimationOptionTransitionCurlUp
                      options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        
                        //any animatable attribute here.
                        cell.frame = CGRectMake(3, 14, 100, 100);
                        
                    } completion:^(BOOL finished) {
                        
                        //whatever you want to do upon completion
                        
                    }];
    
}


#pragma mark - UICollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (messages.count > 0) {
        return [messages count] + 1;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.item < messages.count) {
        
        // pre-fetch the next 'page' of data.
        if(indexPath.item == (messages.count - ITEMS_PAGE_SIZE + 1)){
            [self getMoreData];
        }
        return [self itemCellForIndexPath:indexPath];
    } else {
        [self getMoreData];
        return [self loadingCellForIndexPath:indexPath];
    }

}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    
    Cell *cell = (Cell *)[self.theCollectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retVal = CGSizeMake(320, 500);
    
    return retVal;
}


@end
