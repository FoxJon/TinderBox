//
//  TBAViewController.m
//  TinderBox
//
//  Created by Jonathan Fox on 7/30/14.
//  Copyright (c) 2014 Jon Fox. All rights reserved.

#import "TBAViewController.h"
#import "TBARequestData.h"
#import "TBAListing.h"


@interface TBAViewController ()

@property (nonatomic) UILabel * infoLabel;
@property (nonatomic) UISnapBehavior * snap;
@property (nonatomic) UIDynamicAnimator * animator;
@property (nonatomic) float tap;
@property (nonatomic) int index;

@property (nonatomic) TBAListing *listing;

@end

@implementation TBAViewController
{
    UIView * grayBox;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeGrayBox) name:@"TBAListingDidFinishLoading" object:nil];
        self.index = 0;
        [self fetchListing];
    }
    return self;
}


-(TBAListing *)listing{
    if (!_listing) self.listing = [[TBAListing alloc]init];
    return _listing;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)makeGrayBox {
    [self createBox];
    [self setupLabel];
    [self setupPhoto];
    [self setupDynamics];
    
    [UIView animateWithDuration:0.4 animations:^{
        grayBox.alpha = 1;
    }];
}


-(void)removeGrayBoxAndMakeNewBox {
    [grayBox removeFromSuperview];
    [UIView animateWithDuration:0.4 animations:nil];
    
    if (self.index > self.listing.makeInfo.count-1) {
        self.index = 0;
        [self fetchListing];
    }else{
        [self makeGrayBox];
    }
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    self.tap = location.y;
}


- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.snap];
    }
    
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint newCenter = grayBox.center;
        newCenter.x += [gestureRecognizer translationInView:self.view].x;
        newCenter.y += [gestureRecognizer translationInView:self.view].y;
        
        grayBox.center = newCenter;
        
        // rotation
        if (self.tap > 175) {
            grayBox.transform = CGAffineTransformMakeRotation(((SCREEN_WIDTH-grayBox.center.x)/SCREEN_WIDTH-.5)/3);
        }
        else if (self.tap < 175) {
            grayBox.transform = CGAffineTransformMakeRotation((grayBox.center.x/SCREEN_WIDTH-.5)/3);
        }
        
        // alpha
        if (grayBox.center.x > SCREEN_WIDTH/2) {
            grayBox.alpha = (SCREEN_WIDTH-grayBox.center.x)/SCREEN_WIDTH+.5;
        }else if (grayBox.center.x < SCREEN_WIDTH/2) {
            grayBox.alpha = (grayBox.center.x)/SCREEN_WIDTH+.5;
        }
        
        //keeps box under finger
        [gestureRecognizer setTranslation:CGPointZero inView:super.view];
    }
    
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //animate off screen or snap back to center
        if (grayBox.center.x < 50) {
            CGFloat X = -600;
            CGFloat Y = grayBox.center.y-210;
            [self animateBoxWithX:X andY:Y];
        } else if (grayBox.center.x > SCREEN_WIDTH-50) {
            CGFloat X = SCREEN_WIDTH+300;
            CGFloat Y = grayBox.center.y-175;
            [self animateBoxWithX:X andY:Y];
        } else {
            [self.animator addBehavior:self.snap];
            [UIView animateWithDuration:0.4 animations:^{
                grayBox.alpha = 1;
            }];
        }
    }
}


- (BOOL)prefersStatusBarHidden {return YES;}


#pragma mark: HELPERS

-(void)createBox{
    grayBox = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-150, 70, 300, 350)];
    grayBox.backgroundColor = [UIColor darkGrayColor];
    grayBox.layer.cornerRadius = 10;
    grayBox.layer.shadowColor = [UIColor blackColor].CGColor;
    grayBox.layer.shadowOpacity = 0.75;
    grayBox.layer.shadowRadius = 15.0;
    grayBox.layer.shadowOffset = (CGSize){0.0,20.0};
    grayBox.alpha = 0;
    [self.view addSubview:grayBox];
}


-(void)setupLabel{
    self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, grayBox.frame.size.height, grayBox.frame.size.width, 60)];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.textAlignment = 1;
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@", self.listing.makeInfo[self.index], self.listing.modelInfo[self.index]];
    [grayBox addSubview:self.infoLabel];
}


-(void)setupPhoto{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:grayBox.bounds];
    imageView.layer.cornerRadius = 10;
    [grayBox addSubview:imageView];
    
    NSURL * imageURL = [NSURL URLWithString:self.listing.photo[self.index]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    imageView.image = image;
    imageView.layer.masksToBounds = YES;
    
    self.index++;
}


-(void)setupDynamics{
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.snap = [[UISnapBehavior alloc]initWithItem:grayBox snapToPoint:CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2-35)];
    UIPanGestureRecognizer * gestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [grayBox addGestureRecognizer:gestureRecognizer];
}


-(void)alert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Please connect to internet and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


-(void)fetchListing{
    [self.listing fetchListingsWithErrorHandler:^(NSError *error) {
        if (error){
            [self alert];
        }
    }];
}


-(void)animateBoxWithX:(CGFloat)X andY:(CGFloat)Y{
    [UIView animateWithDuration:0.175 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations: ^(void) {
                         grayBox.frame = CGRectMake(X, Y, 300, 350);
                     }completion:^(BOOL finished) {
                         [self removeGrayBoxAndMakeNewBox];
                     }];
}


@end
