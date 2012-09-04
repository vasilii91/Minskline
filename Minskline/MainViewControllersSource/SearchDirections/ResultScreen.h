//
//  SecondScreen.h
//  Minsktrans
//
//  Created by Kasnitskij_V on 04.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FromScreen.h"
#import "FullInfoAboutRoute.h"
#import "TypeOfTransport.h"
#import "RequestWithResult.h"
#import "ResultForView.h"
#import "UIImageAdding.h"
#import "KVUILabel.h"
#import "SettingsOfMinsktrans.h"
#import "PleaseWaitAlertView.h"
#import "KVTableViewCellResultScreen.h"
#import "FourthScreen.h"
@class FullInfoAboutRoute;

@interface ResultScreen : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    RequestWithResult *RWR;
    MRouteWithSchedule *MRWS;
    
    // результат будет выводится по очереди, т.е. сначала все
    // возможные автобусы, потом троллейбусы, трамваи и метро.
    // В классе храним через сколько придет, тип транспорта и какой номер.
    ResultForView *mainResultForView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewResult;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, readwrite) NSInteger numberOfTransport;
@property (nonatomic, retain) NSString *textOfCell;
@property (nonatomic, retain) IBOutlet UILabel *labelFrom;
@property (nonatomic, retain) IBOutlet UILabel *labelTo;
@property (nonatomic, retain) IBOutlet UILabel *labelInterval;


-(void)goToHome:(id)sender;
-(void)reloadData;
-(IBAction)clickOnUpdate:(id)sender;

@end
