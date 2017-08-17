//
//  FRPFullSizedPhotoViewModel.m
//  FunctionalReactivePixels
//
//  Created by MAC-MiNi on 2017/8/17.
//  Copyright © 2017年 mcan. All rights reserved.
//

#import"FRPPhotoModel.h"
#import "FRPFullSizedPhotoViewModel.h"

@interface FRPFullSizedPhotoViewModel ()

//Privateaccess
@property (nonatomic,assign) NSInteger initialPhotoIndex;

@end

@implementation FRPFullSizedPhotoViewModel

-(instancetype)initWithPhotoArray:(NSArray*)photoArray
                initialPhotoIndex:(NSInteger)initialPhotoIndex {
    self = [self initWithModel:photoArray];
    if (!self) return nil;
    
    self.initialPhotoIndex = initialPhotoIndex;
    
    return self;
}

-(NSString*)initialPhotoName{
    return [[self photoModelAtIndex:self.initialPhotoIndex] photoName];
}

-(FRPPhotoModel*)photoModelAtIndex:(NSInteger)index{
    if (index < 0 || index > self.model.count - 1) {
        // Index was out of bounds, return nil
        return nil;
    } else {
        return self.model[index]; }
}

@end
