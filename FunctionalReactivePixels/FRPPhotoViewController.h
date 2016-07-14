//
//  FRPPhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by mcan on 12/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPPhotoViewController : UIViewController

-(instancetype)initWithPhotoModel:(FRPPhotoModel*)photoModel index:(NSInteger)photoIndex;

@property (nonatomic,readonly)  NSInteger      photoIndex;
@property (nonatomic,readonly)  FRPPhotoModel   *photoModel;

@end
