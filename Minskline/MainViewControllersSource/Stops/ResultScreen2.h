//
//  ResultScreen2.h
//  Minsktrans
//
//  Created by Vasilii Kasnitski on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
#import "PrettyViews.h"
@class FullInfoAboutRoute;

@interface ResultScreen2 : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
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
@property (nonatomic, retain) IBOutlet UILabel *labelInterval;


-(void)goToHome:(id)sender;
-(void)reloadData;
-(IBAction)clickOnUpdate:(id)sender;

@end