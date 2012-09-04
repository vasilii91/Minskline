//
//  FirstScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultScreen.h"
#import "Schedule.h"
#import "AllRoutesAndStops.h"
#import "SecondScreen.h"


@interface FirstScreen : UIViewController {
    ResultScreen *secondScreen;
    Schedule *workWithFile;
    UIButton *busButton;
    UIButton *trolleybusButton;
    UIButton *tramwayButton;
    UIButton *metroButton;
    
    UIButton *buttonPreviousChosen;
    
    float totalProgress;
    NSMutableArray *arrayOfDirections;
    NSArray *arrayToFavorities;
    
    NSArray *arrayOfDirectionsBus;
    NSArray *arrayOfDirectionsTrolleybus;
    NSArray *arrayOfDirectionsTramway;
    
    BOOL isInitBuses;
    BOOL isInitTrolleybuses;
    BOOL isInitTramways;
}

@property (nonatomic, retain) IBOutlet UIWindow *firstScreenWindow;
@property (nonatomic, retain) ResultScreen *secondScreen;
@property (nonatomic, retain) IBOutlet UIButton *busButton;
@property (nonatomic, retain) IBOutlet UIButton *trolleybusButton;
@property (nonatomic, retain) IBOutlet UIButton *tramwayButton;
@property (nonatomic, retain) IBOutlet UIButton *metroButton;
@property (nonatomic, retain) IBOutlet UIButton *favoriteButton;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;
@property (nonatomic, retain) IBOutlet UILabel* percentageLabel;
@property (nonatomic, retain) IBOutlet UIButton* updateButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;

@property (nonatomic, retain) IBOutlet UIButton *toGetSchedule;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewToRoutes;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewToRoutesBuses;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewToRoutesTrolleybuses;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewToRoutesTramways;

- (void)initializeSecondScreen;
- (IBAction)buttonClickOnOneOfButton:(id)sender;
- (IBAction)buttonClickOnUpdateButton:(id)sender;
- (IBAction)buttonClickOnStopButton:(id)sender;

- (void)createButtonsOfRoutes:(TypeOfTransportEnum)typeOfTransport;
- (void)buttonClickOnRouteButton:(id)sender;

- (void)addDataToArrayOfDirections:(BOOL)isFirstly;

@end
