//
//  sw7DaysViewController.h
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMPullToRefresh.h"
@interface sw7DaysViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate >
{
    NSArray *arrayContent;
    NSString *fontName;
    BEMPullToRefresh *myPTR;
    
    int count;
}

@property(nonatomic,strong) NSMutableData *receivedData;

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (NSString*) translateToLocalized:(NSString*) str;

@end
