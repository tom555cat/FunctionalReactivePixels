//
//  FRPGalleryFlowLayout.m
//  FunctionalReactivePixels
//
//  Created by mcan on 11/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout


- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(145, 145);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return self;
}
@end
