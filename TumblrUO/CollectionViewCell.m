//
//  DemoTableViewCell.m
//  RTLabelProject
//
//  Created by honcheng on 5/1/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import "CollectionViewCell.h"


@implementation CollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
            self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
            
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 3.0f;
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowRadius = 3.0f;
            self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
            self.layer.shadowOpacity = 0.5f;
            
            self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            
            [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.imageView2];
        
    }
    return self;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code.
//		_rtLabel = [CollectionViewCell textLabel];
//		[self.contentView addSubview:_rtLabel];
//		[_rtLabel setBackgroundColor:[UIColor clearColor]];
//        
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//    return self;
//}

- (void)layoutSubviews
{
	[super layoutSubviews];
	

}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state.
//}

@end
