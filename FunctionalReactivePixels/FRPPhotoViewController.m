//
//  FRPPhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by mcan on 12/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import "FRPPhotoViewController.h"

//Model
#import"FRPPhotoModel.h"

//Utilities
#import "FRPPhotoImporter.h"
#import <SVProgressHUD.h>

//ViewModel
#import "FRPPhotoViewModel.h"

@interface FRPPhotoViewController ()

//Privateassignment
@property(nonatomic,assign)NSInteger        photoIndex;
@property(nonatomic,strong)FRPPhotoModel    *photoModel;

//Privateproperties
@property(nonatomic,weak)UIImageView    *imageView;

@property (nonatomic, strong) FRPPhotoViewModel *viewModel;

@end

@implementation FRPPhotoViewController

- (instancetype)initWithViewModel:(FRPPhotoViewModel *)viewModel
                            index:(NSInteger)photoIndex {
    self = [self init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    self.photoIndex = photoIndex;
    
    return self;
}

-(instancetype)initWithPhotoModel:(FRPPhotoModel*)photoModel index:(NSInteger)photoIndex
{
    self = [self init]; if (!self) return nil;
    self.photoModel = photoModel;
    self.photoIndex = photoIndex;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Configure subviews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    RAC(imageView, image) = RACObserve(self.viewModel, photoImage);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber *loading){
        if (loading.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [SVProgressHUD show];
//    
//    // Fetch data
//    [[FRPPhotoImporter fetchPhotoDetails:self.photoModel]
//     subscribeError:^(NSError *error) {
//         [SVProgressHUD showErrorWithStatus:@"Error"];
//     } completed:^{
//         [SVProgressHUD dismiss];
//     }];
    self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.viewModel.active = NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
