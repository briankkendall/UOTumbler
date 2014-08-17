//
//  UOFeedCollectionViewController.h
//  TumblrUO
//
//  Created by bkendall on 8/13/14.
//  Copyright (c) 2014 bkendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "Reachability.h"

@interface UOFeedCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger _currentPage;
    NSInteger _numRetrieved;
    NSMutableData *responseData;
    NSMutableArray *messages;
    NSDictionary *responseDict;
    Reachability *reachability;
}
//view header related
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;


@property (weak, nonatomic) IBOutlet UICollectionView *theCollectionView;


@property (weak, nonatomic) IBOutlet CollectionViewCell *customCollectionViewCell;
@property (weak, nonatomic) IBOutlet UILabel *lblCellLabel;

@property (nonatomic, retain) NSString *selectedBlogUsername;
- (void)setResponseDict: (NSDictionary *)responseDictionary;
- (void)getMoreData;

@end
