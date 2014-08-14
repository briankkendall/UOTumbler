//
//  DemoTableViewCell.h
//  RTLabelProject
//
//  Created by honcheng on 5/1/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) RTLabel *rtLabel;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
+ (RTLabel*)textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgTumblr;
@end
