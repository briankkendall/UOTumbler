//
//  UOFeedCollectionViewController.h
//  TumblrUO
//
//  Created by bkendall on 8/13/14.
//  Copyright (c) 2014 bkendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"

@interface UOFeedCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,RTLabelDelegate>
{
    NSInteger _currentPage;
    NSInteger _numRetrieved;
    NSMutableData *responseData;
    NSMutableArray *messages;
    NSDictionary *responseDict;

}
//view header related
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;


@property (weak, nonatomic) IBOutlet UICollectionView *theCollectionView;


@property (weak, nonatomic) IBOutlet CollectionViewCell *customCollectionViewCell;
@property (weak, nonatomic) IBOutlet UILabel *lblCellLabel;
- (void)setResponseDict: (NSDictionary *)responseDictionary;
- (void)getMoreData;

@end
