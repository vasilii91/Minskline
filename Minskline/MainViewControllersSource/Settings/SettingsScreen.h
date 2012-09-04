//
//  FourthScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullInfoAboutRoute.h"
#import "SettingsOfMinsktrans.h"
#import "AllRoutesAndStops.h"
#import "AppDelegate.h"
#import "Schedule.h"
#import "PDColoredProgressView.h"
#import "PrettyViews.h"

@interface SettingsScreen : UIViewController<NSURLConnectionDelegate, UIAlertViewDelegate> {
    IBOutlet UIImageView *imageViewDirection;
    NSArray *intervals;
    
    NSMutableData *receivedData;
    NSString *updateDate;
    NSString *updateSize;
    NSString *currentUpdateDate;

    NSUserDefaults *def;
    SettingsOfMinsktrans *settings;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControlToInterval;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedIsFavorite;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControlSortType;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerViewInterval;
@property (nonatomic, retain) IBOutlet PDColoredProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIButton *buttonUpdate;
@property (nonatomic, retain) IBOutlet UILabel *labelUpdateStatus;

-(IBAction)selectSegmentedControl:(id)sender;
-(IBAction)selectSegmentedControlIsFavorite:(id)sender;
-(IBAction)selectSegmentedControlTypeOfSort:(id)sender;
-(IBAction)updateDatabase:(id)sender;

@end
