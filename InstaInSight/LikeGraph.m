//
//  LikeGraph.m
//  InstaInSight
//
//  Created by Mukesh Verma on 03/02/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "LikeGraph.h"

@interface LikeGraph ()

@end

@implementation LikeGraph

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Like Graph For Last 7 Posts"];

//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleLabel.text = @"Like Graph";
//    [titleLabel sizeToFit];
//    
//    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 0, 0)];
//    subTitleLabel.backgroundColor = [UIColor clearColor];
//    subTitleLabel.textColor = [UIColor whiteColor];
//    subTitleLabel.font = [UIFont systemFontOfSize:12];
//    subTitleLabel.text = @"Last 7 Posts";
//    [subTitleLabel sizeToFit];
//    
//    UIView *twoLineTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(subTitleLabel.frame.size.width, titleLabel.frame.size.width), 30)];
//    [twoLineTitleView addSubview:titleLabel];
//    [twoLineTitleView addSubview:subTitleLabel];
//    
//    float widthDiff = subTitleLabel.frame.size.width - titleLabel.frame.size.width;
//    
//    if (widthDiff > 0) {
//        CGRect frame = titleLabel.frame;
//        frame.origin.x = widthDiff / 2;
//        titleLabel.frame = CGRectIntegral(frame);
//    }else{
//        CGRect frame = subTitleLabel.frame;
//        frame.origin.x = fabsf(widthDiff) / 2;
//        subTitleLabel.frame = CGRectIntegral(frame);
//    }
//    
//    self.navigationItem.titleView = twoLineTitleView;
    
    
    [FIRAnalytics setScreenName:@"LikeGraph" screenClass:@"LikeGraph"];
    [self setScreenName:@"LikeGraph"];
    
    arrTotalLikers=[[NSMutableArray alloc] init];
    arrTopMedia=[[NSMutableArray alloc] init];
    
    [myGraph setHidden:YES];
   // [myGraph setClipsToBounds:YES];
    
    [self FetchRecentFeeds];
    
    //[self.view setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    if (myGraph) {
      [myGraph reloadGraph];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FetchRecentFeeds
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithCount:7 maxId:nil success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"media = %@",media);
        
        NSArray* reversed = [[media reverseObjectEnumerator] allObjects];
        
        arrTopMedia=[[NSMutableArray alloc] initWithArray:reversed];
        
        [arrTopMedia reverseObjectEnumerator];
       
        [actView stopAnimating];
        [self DrawGraph];
        [myGraph setHidden:NO];
        [myGraph reloadGraph];
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
}

-(void)DrawGraph
{

    [myGraph setEnableBezierCurve:YES];
    
    myGraph.enableTouchReport = YES;
    myGraph.enablePopUpReport = YES;
    
    myGraph.enableYAxisLabel = YES;
    myGraph.autoScaleYAxis = YES;
    
    myGraph.enableXAxisLabel = YES;
    myGraph.alwaysDisplayDots = NO;
    myGraph.enableReferenceXAxisLines = YES;
    myGraph.enableReferenceYAxisLines = YES;
    myGraph.enableReferenceAxisFrame = YES;
    
    // Draw an average line
    myGraph.averageLine.enableAverageLine = YES;
    myGraph.averageLine.alpha = 0.6;
    myGraph.averageLine.color = [UIColor whiteColor];
    myGraph.averageLine.width = 1;
    myGraph.averageLine.dashPattern = @[@(1),@(1)];
    
    // Set the graph's animation style to draw, fade, or none
    myGraph.animationGraphStyle = BEMLineAnimationFade;
    
    // Dash the y reference lines
    myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    myGraph.formatStringForValues = @"%.1f";
    
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    // Apply the gradient to the bottom portion of the graph
    myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
}

- (NSInteger)randomNumberBetween:(uint32_t)min maxNumber:(uint32_t)max
{
    return min + arc4random_uniform(max - min + 1);
}

#pragma mark-
#pragma mark- BEMSimpleLineGraphView Delegate and DataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [arrTopMedia count]; // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    // The value of the point on the Y-Axis for the index.
    InstagramMedia *media=[arrTopMedia objectAtIndex:index];
    CGFloat likeCount=(float) (media.likesCount);
    return likeCount;
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    return @"";
}

//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
//    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
//    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self labelForDateAtIndex:index]];
//}
//
//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.labelValues.alpha = 0.0;
//        self.labelDates.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//        self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.labelValues.alpha = 1.0;
//            self.labelDates.alpha = 1.0;
//        } completion:nil];
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

@end
