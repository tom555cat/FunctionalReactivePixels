//
//  FRPCell.h
//  FunctionalReactivePixels
//
//  Created by mcan on 12/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPPhotoModel.h"


@interface FRPCell : UICollectionViewCell

@property (nonatomic, strong) FRPPhotoModel *photoModel;

-(void)setPhotoModel:(FRPPhotoModel*)photoModel;

@end
