//
//  swNowViewController.h
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface swNowViewController : UIViewController <NSURLConnectionDataDelegate>
{
    NSString *strTempDegree;
    NSString *strHumidity;
    NSString *strUV;
    NSString *strUpdateTime;
    NSString *strForecast;
    NSString *Desc;
    
}

@property(nonatomic,strong) NSMutableData *receivedData;
@property(nonatomic,strong) IBOutlet UIImageView *imageViewCenter;
@property(nonatomic,strong) IBOutlet UILabel *lblTempDegree;
@property(nonatomic,strong) IBOutlet UILabel *lblHumidity;
@property(nonatomic,strong) IBOutlet UILabel *lblDesc;

@property(nonatomic,strong) IBOutlet UILabel *lblWarning;

@property(nonatomic,strong) IBOutlet UILabel *lblUpdateTime;

@property(nonatomic,strong) IBOutlet UILabel *lblRefresh;

@property(nonatomic,strong) IBOutlet UIButton *btnShowDrag;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

@end
