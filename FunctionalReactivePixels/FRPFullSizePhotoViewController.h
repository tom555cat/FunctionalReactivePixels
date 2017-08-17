//
//  FRPFullSizePhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by mcan on 12/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPFullSizePhotoViewModel;

@class FRPFullSizePhotoViewController;

@protocol FRPFullSizePhotoViewControllerDelegate <NSObject>

-(void) userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index;

@end



@interface FRPFullSizePhotoViewController : UIViewController

//-(instancetype)initWithPhotoModels:(NSArray*)photoModelArray currentPhotoIndex:(NSInteger)photoIndex;

@property (nonatomic, strong) FRPFullSizePhotoViewModel *viewModel;

@property (nonatomic,readonly) NSArray *photoModelArray;
@property (nonatomic,weak) id <FRPFullSizePhotoViewControllerDelegate> delegate;

@end
