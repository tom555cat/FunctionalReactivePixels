//
//  FRPPhotoImporter.h
//  FunctionalReactivePixels
//
//  Created by mcan on 11/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRPPhotoModel.h"

@interface FRPPhotoImporter : NSObject

+(RACSignal*)importPhotos;

+(RACReplaySubject*)fetchPhotoDetails:(FRPPhotoModel*)photoModel;

@end
