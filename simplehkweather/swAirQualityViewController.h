//
//  swAirQualityViewController.h
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface swAirQualityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
{
    
    NSMutableString *currentStringValue;
    BOOL parserGapName, parserGapBand , parseGapRisk, parseHeader;
    
    NSMutableArray *arrayPlace ;
    NSMutableArray *arrayBand ;
    NSMutableArray *arrayRisk ;
    
    NSMutableArray *arrayHeader;
    
    NSString *urlString;
    UILabel *lblUpdateTime;
}
@property (nonatomic, strong) NSXMLParser *xhtmlParser;

@property(nonatomic,strong) NSMutableData *receivedData;


@property(nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
- (NSString*) translateToLocalized:(NSString*) str;


@end
