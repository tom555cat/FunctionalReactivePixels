//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by mcan on 11/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter



+(RACReplaySubject*)importPhotos{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSURLRequest *request = [self popularURLRequest];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            id results = [NSJSONSerialization
                          JSONObjectWithData:data options:0 error:nil];
            [subject sendNext:[[[results[@"photos"] rac_sequence] map: ^id(NSDictionary *photoDictionary) {
                FRPPhotoModel *model = [FRPPhotoModel new];
                [self configurePhotoModel:model
                           withDictionary:photoDictionary];
                [self downloadThumbnailForPhotoModel:model];
                return model; }] array]];
            [subject sendCompleted];
        }
        else {
            [subject sendError:connectionError];
        } }];
    return subject;
}


+(void)configurePhotoModel:(FRPPhotoModel*)photoModel withDictionary:(NSDictionary*)dictionary{
    // Basics details fetched with the first, basic request
    photoModel.photoName = dictionary[@"name"];
    photoModel.identifier = dictionary[@"id"];
    photoModel.photographerName = dictionary[@"user"][@"username"];
    photoModel.rating = dictionary[@"rating"];
    photoModel.thumbnailURL = [self urlForImageSize:3 inDictionary:dictionary[@"images"]];
    // Extended attributes fetched with subsequent request
    if (dictionary[@"comments_count"]) { photoModel.fullsizedURL = [self urlForImageSize:4 inDictionary:dictionary[@"images"]];
    }
}

+ (NSString *) urlForImageSize:(NSInteger)size inDictionary:(NSDictionary *) array{
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array] firstObject];
}

+(void)downloadThumbnailForPhotoModel:(FRPPhotoModel*)photoModel{
    [self download:photoModel.thumbnailURL
    withCompletion:^(NSData *data) {
        photoModel.thumbnailData = data;
    }];
}

+(void)downloadFullsizedImageForPhotoModel:(FRPPhotoModel*)photoModel{
    [self download:photoModel.fullsizedURL withCompletion:^(NSData *data) {
        photoModel.fullsizedData = data;
    }];
}

+(void)download:(NSString*)urlString withCompletion:(void(^)(NSData *data))completion {
    NSAssert(urlString, @"URL must not be nil");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                               if (completion) {
                                   completion(data);
                               }
                           }];
}

+(NSURLRequest*)photoURLRequest:(FRPPhotoModel*)photoModel{
    return [[PXRequest apiHelper] urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+(RACReplaySubject*)fetchPhotoDetails:(FRPPhotoModel*)photoModel{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSURLRequest *request = [self photoURLRequest:photoModel];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"photo"];
            [self configurePhotoModel:photoModel withDictionary:results];
            [self downloadFullsizedImageForPhotoModel:photoModel];
            [subject sendNext:photoModel];
            [subject sendCompleted];
        }
        else{
            [subject sendError:connectionError];
        }
    }];
    return subject;
}

+(NSURLRequest*)popularURLRequest{
    return [[PXRequest apiHelper] urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular
                                             resultsPerPage:100
                                                       page:0
                                                 photoSizes:PXPhotoModelSizeThumbnail
                                                  sortOrder:PXAPIHelperSortOrderRating
                                                     except:PXPhotoModelCategoryNude];
}
@end
