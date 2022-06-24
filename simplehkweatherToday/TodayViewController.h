//
//  TodayViewController.h
//  任何天氣 Any Weather
//
//  Created by carladmin on 23/7/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
{
    NSString *strTempDegree;
    NSString *strHumidity;
    NSString *strUV;
    NSString *strUpdateTime;
    NSString *strForecast;
    NSString *Desc;
    
}


@property(nonatomic,strong) IBOutlet UILabel *lblTempDegree;
//@property(nonatomic,strong) IBOutlet UILabel *lblHumidity;
//@property(nonatomic,strong) IBOutlet UILabel *lblUV;
@property(nonatomic,strong) IBOutlet UILabel *lblDesc;
@property(nonatomic,strong) IBOutlet UIImageView *imageViewIcon;

@end
