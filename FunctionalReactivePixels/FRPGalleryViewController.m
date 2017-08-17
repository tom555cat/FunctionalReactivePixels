//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by mcan on 11/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import <ReactiveCocoa/RACDelegateProxy.h>
#import "FRPGalleryViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPPhotoImporter.h"
#import "FRPCell.h"
#import "FRPFullSizePhotoViewController.h"
@interface FRPGalleryViewController ()

@property(nonatomic,strong)NSArray*photosArray;

@property (nonatomic, strong) id collectionViewDelegate;

@end

@implementation FRPGalleryViewController

static NSString * const reuseIdentifier = @"Cell";

-(id)init
{
    FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) return nil;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure Self
    self.title = @"Popular on 500px";
    
    // Configure View
    [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Reactive
    @weakify(self);
    [RACObserve(self, photosArray) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    //[self loadPopularPhotos];
    /** 使用信号来代替loadPopularPhotos **/
//    RACSignal *photoSignal = [FRPPhotoImporter importPhotos];
//    RACSignal *photosLoaded = [photoSignal catch:^RACSignal *(NSError *error) {    // catch:非错误放行，错误留下
//        NSLog(@"Couldn't fetch photos from 500px: %@", error);
//        return [RACSignal empty];
//    }];
//    RAC(self, photosArray) = photosLoaded;
//    [photosLoaded subscribeCompleted:^{
//        @strongify(self);
//        [self.collectionView reloadData];
//    }];
    
    // 这个one-way binding是上面的简洁写法，将信号绑定到属性上
    RAC(self, photosArray) = [[[[FRPPhotoImporter importPhotos]
        doCompleted:^{                                                  // doCompleted
            @strongify(self);
            [self.collectionView reloadData];
        }] logError] catchTo:[RACSignal empty]];
    
    /** 使用RACDelegateProxy来代替传统的Delegate实现方式 **/
    
    // FRPFullSizePhotoViewControllerDelegate代理在RAC中的使用
//    RACDelegateProxy *viewControllerDelegate = [[RACDelegateProxy alloc]
//        initWithProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)];
//    
//    [[viewControllerDelegate rac_signalForSelector:@selector(userDidScroll:toPhotoAtIndex:)
//        fromProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)]
//     subscribeNext:^(RACTuple *value) {
//         @strongify(self);
//         [self.collectionView scrollToItemAtIndexPath:
//            [NSIndexPath indexPathForItem:[value.second integerValue] inSection:0]
//            atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
//     }];
    
    // UICollectionViewDelegate代理在RAC中的使用
//    self.collectionViewDelegate = [[RACDelegateProxy alloc]
//        initWithProtocol:@protocol(UICollectionViewDelegate)];
//    [[self.collectionViewDelegate rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)]
//     subscribeNext:^(RACTuple *arguments) {
//         @strongify(self);
//         FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc]
//            initWithPhotoModels:self.photosArray currentPhotoIndex:[(NSIndexPath *)arguments.second item]];
//         viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)viewControllerDelegate;
//         [self.navigationController pushViewController:viewController animated:YES];
//     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)loadPopularPhotos{
//    [[FRPPhotoImporter importPhotos] subscribeNext:^(id x) {
//        self.photosArray = x;
//    } error:^(NSError *error) {
//        NSLog(@"Couldn't fetch photos from 500px: %@",
//              error);
//    }];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


/** 使用RACDelegateProxy代替 **/

-(void)userDidScroll:(FRPFullSizePhotoViewController*)viewController toPhotoAtIndex:(NSInteger)index {
    [self.collectionView scrollToItemAtIndexPath:
     [NSIndexPath indexPathForItem:index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];
}




#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setPhotoModel:self.photosArray[indexPath.row]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/** 使用RACDelegateProxy代替 **/

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] initWithPhotoModels:self.photosArray currentPhotoIndex:indexPath.item];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
