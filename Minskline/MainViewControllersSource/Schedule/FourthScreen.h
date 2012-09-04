//
//  FourthScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingLabel.h"
#import "Times.h"
#import "FullInfoAboutRoute.h"
#import "AllRoutesAndStops.h"
#import "ResultForView.h"
#import "UIImageAdding.h"
#import "KVUILabel.h"
#import "PrettyViews.h"
#import "QuartzCore/QuartzCore.h"

@interface FourthScreen : UIViewController {
    // ---<ResultForView>---
    ResultForView *scheduleFull;
    BOOL isEqualSaturdayAndSunday;
    BOOL isSaturdayFull;
    BOOL isSundayFull;
    
    // ----<Hour, NSMutableArray<Minute>>----
    NSMutableDictionary *dictionarySchedule;
    NSMutableArray *sortedArrayOfHours;
    
    ResultForView *resultForView;
    
    NSInteger dayOfWeek;
    BOOL isWorkDayChosen;
    
    UILabel *labelEmptySchedule;
}

@property (nonatomic, retain) NSString *numberOfTransport;
@property (nonatomic, assign) TypeOfTransportEnum typeOfTransport;
@property (nonatomic, retain) Routes *currentRoute;
@property (nonatomic, retain) Stops *currentStop;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewSchedule;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *buttonWorkdays;
@property (nonatomic, retain) IBOutlet UIButton *buttonHolydays;
@property (nonatomic, retain) IBOutlet UIButton *buttonSaturday;
@property (nonatomic, retain) IBOutlet UIButton *buttonSunday;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

- (IBAction)clickToWorkdays:(id)sender;
- (IBAction)clickToHolidays:(id)sender;
- (IBAction)clickToSaturday:(id)sender;
- (IBAction)clickToSunday:(id)sender;

- (void)reloadData;
- (void)reloadButtons;
- (void)clickToNeedButton;
- (void)createLabelsWithSchedule;
- (void)buttonClickToMinutes:(id)sender;
-(void)goToHome:(id)sender;

@end
