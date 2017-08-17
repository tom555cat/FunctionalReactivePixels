//
//  FRPGalleryViewModel.m
//  FunctionalReactivePixels
//
//  Created by MAC-MiNi on 2017/8/17.
//  Copyright © 2017年 mcan. All rights reserved.
//

#import "FRPGalleryViewModel.h"
#import "FRPPhotoImporter.h"

@implementation FRPGalleryViewModel

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    
    // 作者将获取网络数据直接写在了这里，认为是有争议的
    RAC(self, model) = [[[FRPPhotoImporter importPhotos] logError] catchTo:[RACSignal empty]];
    
    return self;
}


@end
