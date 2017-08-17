//
//  FRPFullSizePhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by mcan on 12/07/16.
//  Copyright © 2016 mcan. All rights reserved.
//

#import "FRPFullSizePhotoViewController.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoViewController.h"
#import "FRPFullSizePhotoViewModel"

@interface FRPFullSizePhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
//Privateassignment
@property(nonatomic,strong)NSArray*photoModelArray;


//Privateproperties
@property(nonatomic,strong)UIPageViewController*pageViewController;

@end

@implementation FRPFullSizePhotoViewController

-(instancetype)initWithPhotoModels:(NSArray*)photoModelArray currentPhotoIndex:(NSInteger)photoIndex
{
    self = [self init];
    if (!self) return nil;
    
    // View controllers
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:
                               UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:
                               UIPageViewControllerNavigationOrientationHorizontal
                               options:
                               @{UIPageViewControllerOptionInterPageSpacingKey: @(30)}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];

    // Configure child view controllers
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex: self.viewModel.initialPhotoIndex]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO completion:nil];
    //Configureself
    self.title=[self.viewModel.initialPhotoModel photoName];
    
    return  self;
    
}

-(FRPPhotoViewController*)photoViewControllerForIndex:(NSInteger)index {
    FRPPhotoModel *photoModel = [self.viewModel photoModelAtIndex:index];
    if (photoModel) {
        FRPPhotoViewModel *photoViewModel = [[FRPPhotoViewModel alloc] initWithModel:photoModel];
        FRPPhotoViewController *photoViewController = [[FRPPhotoViewController alloc] initWithViewModel:photoViewModel index:index];
        return photoViewController;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure self's view
    self.view.backgroundColor = [UIColor blackColor];
    
    // Configure subviews
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    self.title = [[self.pageViewController.viewControllers.firstObject photoModel] photoName];
    [self.delegate userDidScroll:self toPhotoAtIndex:[self.pageViewController.viewControllers.firstObject photoIndex]];
}

-(UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

-(UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
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
