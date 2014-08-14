//
//  UOFeedCollectionViewController.m
//  TumblrUO
//
//  Created by bkendall on 8/13/14.
//  Copyright (c) 2014 bkendall. All rights reserved.
//

#import "UOFeedCollectionViewController.h"
#import "Cell.h"


#define ITEMS_PAGE_SIZE 20
#define ITEM_CELL_IDENTIFIER @"UOTumblrCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"
#define STR_O_CONSUMER_KEY  @"AWsfhrXeaMwPHv9z0QYrgIG9A5UmYecvYVFI4LvHGJURP1PaoE";
@interface UOFeedCollectionViewController ()

@end

@implementation UOFeedCollectionViewController
@synthesize avatarImage;
@synthesize lblUsername, lblDescription;
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

    
    NSString *strOConsumerKey = STR_O_CONSUMER_KEY;
    responseData = [[NSMutableData alloc] init];
    messages = [NSMutableArray array];
    NSString *nameOrUrlString = [[[responseDict objectForKey:@"response"] objectForKey:@"blog"] objectForKey:@"url"];
    nameOrUrlString = [nameOrUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    nameOrUrlString = [nameOrUrlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *strImagePath;
    strImagePath = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/avatar/16", nameOrUrlString];
    
    //set the avatar image
    NSURL * imageURL = [NSURL URLWithString: strImagePath];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    avatarImage.image = image;
    
    //set the username and the description
    lblUsername.text = [[[responseDict objectForKey:@"response"] objectForKey:@"blog"] objectForKey:@"name"];
    lblDescription.text = [[[responseDict objectForKey:@"response"] objectForKey:@"blog"] objectForKey:@"description"];
    
    nameOrUrlString = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/posts?api_key=%@", nameOrUrlString, strOConsumerKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:nameOrUrlString]];
    
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.theCollectionView registerClass:[Cell class] forCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER];
    [self.theCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    _numRetrieved = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMoreData {
    
    // Generate the 'next page' of data.
//    NSMutableArray *newData = [NSMutableArray array];
//    NSInteger pageSize = ITEMS_PAGE_SIZE;
//    for (int i = _currentPage * pageSize; i < ((_currentPage * pageSize) + pageSize); i++) {
//        [newData addObject:[NSString stringWithFormat:@"Item #%d", i]];
//    }
    
    _currentPage++;
    
    NSString *strOConsumerKey = STR_O_CONSUMER_KEY;
    responseData = [[NSMutableData alloc] init];
    //messages = [NSMutableArray array];
    NSString *nameOrUrlString = [[[responseDict objectForKey:@"response"] objectForKey:@"blog"] objectForKey:@"url"];
    nameOrUrlString = [nameOrUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    nameOrUrlString = [nameOrUrlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    
    nameOrUrlString = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/posts/?api_key=%@&offset=%i", nameOrUrlString, strOConsumerKey, _currentPage * ITEMS_PAGE_SIZE];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:nameOrUrlString]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    
    Cell *cell = (Cell *)[self.theCollectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Update the custom cell with some text
    cell.titleLabel.text = [NSString stringWithFormat:@"Fetched item: %d", indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *tmpDict = [[[messages objectAtIndex:indexPath.row] objectForKey:@"photos"] objectAtIndex:0];
    NSURL * imageURL = [NSURL URLWithString: [[tmpDict objectForKey:@"original_size"] objectForKey:@"url"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(5,5, 100, 100)];
    imv.image=[UIImage imageWithData:imageData];
    [cell addSubview:imv];
    //cell.titleLabel.lineSpacing = 20.0;
    return cell;
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Select item
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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

    NSString *strCaption;
    
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


#pragma mark NSURLConnection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //clear out the response...
    [responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //set the responseData to the data coming back from the call...
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
            if ([messages count] > 0) {
                // Add the new data to our local collection of data.
                for (int i = 0; i < [[[responseDict objectForKey:@"response"] objectForKey:@"posts"] count]; i++) {
                    [messages addObject: [[[responseDict objectForKey:@"response"] objectForKey:@"posts"] objectAtIndex:i]];
                }
            }else{
                messages = [NSMutableArray arrayWithArray:[[responseDict objectForKey:@"response"] objectForKey:@"posts"]];
            }
            _numRetrieved += ITEMS_PAGE_SIZE;
            //[self performSegueWithIdentifier:@"showFeed" sender:self];
            [theCollectionView reloadData];
            
            
        }else{
            //error
            
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retVal = CGSizeMake(200, 200);
    
    return retVal;
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
	NSLog(@"did select url %@", url);
}

@end
