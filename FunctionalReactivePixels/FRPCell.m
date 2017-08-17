//
//  FRPCell.m
//  FunctionalReactivePixels
//
//  Created by mcan on 12/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import "FRPCell.h"

@interface FRPCell()

@property (nonatomic,weak)   UIImageView* imageView;
@property (nonatomic,strong) RACDisposable* subscription;

@end

@implementation FRPCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    return self;
}

-(void)setPhotoModel:(FRPPhotoModel*)photoModel{
    /** RACObserve **/
    self.subscription = [[[RACObserve(photoModel, thumbnailData) filter:^BOOL(id value) {
            return value != nil;
        }] map:^id(id value) {
            return [UIImage imageWithData:value];
        }] setKeyPath:@keypath(self.imageView, image) onObject:self.imageView];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self.subscription dispose], self.subscription = nil;
}

@end
