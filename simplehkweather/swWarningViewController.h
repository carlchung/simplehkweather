//
//  swWarningViewController.h
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface swWarningViewController : UIViewController 
{
    NSString *urlString;
    NSString *strLongText;
    int countWarning;
}


@property(nonatomic,strong) NSMutableData *receivedData;

//@property(nonatomic,strong) IBOutlet UILabel *lblWarningTitle;
//@property(nonatomic,strong) IBOutlet UILabel *lblBigOne;
@property(nonatomic,strong) IBOutlet UITextView *textViewBig;

@property(nonatomic,strong) IBOutlet UILabel *lblRefresh;


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
@end
