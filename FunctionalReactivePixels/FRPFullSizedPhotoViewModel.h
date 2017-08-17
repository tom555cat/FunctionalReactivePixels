//
//  FRPFullSizedPhotoViewModel.h
//  FunctionalReactivePixels
//
//  Created by MAC-MiNi on 2017/8/17.
//  Copyright © 2017年 mcan. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class FRPPhotoModel;

@interface FRPFullSizedPhotoViewModel : RVMViewModel

- (instancetype)initWithPhotoArray:(NSArray*)photoArray initialPhotoIndex:(NSInteger)initialPhotoIndex;

- (FRPPhotoModel *)photoModelAtIndex:(NSInteger)index;

@property (nonatomic, readonly, strong) NSArray *model;
@property (nonatomic, readonly) NSInteger initialPhotoIndex;
@property (nonatomic, readonly)NSString *initialPhotoName;

@end
