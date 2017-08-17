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

@interface FRPPhotoViewController ()

//Privateassignment
@property(nonatomic,assign)NSInteger        photoIndex;
@property(nonatomic,strong)FRPPhotoModel    *photoModel;

//Privateproperties
@property(nonatomic,weak)UIImageView    *imageView;

@end

@implementation FRPPhotoViewController



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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    /** 双向绑定 **/
    RAC(imageView,image) = [RACObserve(self.photoModel, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SVProgressHUD show];
    
    // Fetch data
    [[FRPPhotoImporter fetchPhotoDetails:self.photoModel]
     subscribeError:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"Error"];
     } completed:^{
         [SVProgressHUD dismiss];
     }];
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
