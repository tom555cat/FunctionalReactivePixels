//
//  FRPPhotoModel.h
//  FunctionalReactivePixels
//
//  Created by mcan on 11/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPPhotoModel : NSObject

@property (nonatomic,strong) NSString *photoName;
@property (nonatomic,strong) NSNumber *identifier;
@property (nonatomic,strong) NSString *photographerName;
@property (nonatomic,strong) NSNumber *rating;
@property (nonatomic,strong) NSString *thumbnailURL;
@property (nonatomic,strong) NSData *thumbnailData;
@property (nonatomic,strong) NSString *fullsizedURL;
@property (nonatomic,strong) NSData *fullsizedData;


@end
