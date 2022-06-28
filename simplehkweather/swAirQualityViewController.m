//
//  swAirQualityViewController.m
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import "swAirQualityViewController.h"
#import "swAppDelegate.h"
#define kRSS_URL_aqhirss @"http://www.aqhi.gov.hk/epd/ddata/html/out/aqhirss_Eng.xml"
#define kURL_aqhiXML @"http://www.aqhi.gov.hk/mobile/gt6217.html?device=xhtml"
#define kURL_aqhiXML_zh_hk @"http://www.aqhi.gov.hk/mobile/gt6217.html?device=xhtml" //@"http://www.aqhi.gov.hk/mobile/tc6217.html?device=xhtml"

@interface swAirQualityViewController ()

@end

@implementation swAirQualityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    
    [self.tableView setAlpha:0.0];
    parserGapName = NO;
    parserGapBand = NO;
    parseGapRisk = NO;
    parseHeader = NO;

    arrayHeader = [NSMutableArray arrayWithCapacity:0];
    arrayPlace = [NSMutableArray arrayWithCapacity:0];
    arrayBand = [NSMutableArray arrayWithCapacity:0];
    arrayRisk = [NSMutableArray arrayWithCapacity:0];
    //self.tabBarItem.title = LString(@"M_AIR", nil);
    
    [self loadAirIndexXML];
//
//    lblUpdateTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
//    lblUpdateTime.text = @"";
//    lblUpdateTime.font = [UIFont fontWithName: @"BodoniSvtyTwoITCTT-Book" size:13.0];
//    lblUpdateTime.textColor = [UIColor lightGrayColor];
//    lblUpdateTime.textAlignment = NSTextAlignmentCenter;

//    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
//    [viewFooter addSubview:lblUpdateTime];
//    [self.tableView setTableFooterView:viewFooter];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(self.tableView.frame.size.width/2+15, 25, 30, 30);
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadAirIndexXML];
    [refreshControl endRefreshing];
}

- (void) loadAirIndexXML
{
    
    // Create the request.
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"lang %@", language);
    if ( [language hasPrefix:@"zh"]) {
        urlString = kURL_aqhiXML_zh_hk;
    } else {
        urlString = kURL_aqhiXML;
    }
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10.0];
    
    // create the connection with the request
    // and start loading the data
    // note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                    if ( error ) {
                                        
//                                        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"Connection Problem" message:@"Fail to connect to network, please check your cellular network or WIFI setting."  delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                                        [connectFailMessage show];
                                        UIAlertController * alert = [UIAlertController
                                                                     alertControllerWithTitle:@"Connection failed! "
                                                                     message:@""
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                            //do something when click button
                                        }];
                                        [alert addAction:okAction];
                                        [self presentViewController:alert animated:YES completion:nil];
                                        return;
                                    }
                                    
                                    [arrayHeader removeAllObjects];
                                    
                                    [arrayPlace removeAllObjects];
                                    [arrayBand removeAllObjects];
                                    [arrayRisk removeAllObjects];
                                    
                                    NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                                    NSLog(@"Air xhtml %@", dataString);
                                    
                                    NSArray *arrayTop = [dataString componentsSeparatedByString:@"tblCurrAQHI_tdName"];
                                    
                                    for (int i=1 ; i<arrayTop.count; i++ ){
                                        NSLog(@"arrayTop%d ",i);
                                        NSString *rowString = arrayTop[i];
                                        NSArray *arrayRow = [rowString componentsSeparatedByString:@">"];
                                        
                                        for (int i=0 ; i<arrayRow.count; i++ ){
                                            NSLog(@"arrayRow%d %@",i, arrayRow[i] );
                                            if ( i == 2 ) {
                                                NSString *placeString = arrayRow[i];
                                                [arrayPlace addObject: [placeString stringByReplacingOccurrencesOfString:@"</a" withString:@""]];
                                                
                                            }
                                            if ( i == 5 ) {
                                                NSString *indexString = [arrayRow[i] substringToIndex:3] ;
                                                [arrayBand addObject: [[indexString stringByReplacingOccurrencesOfString:@"<" withString:@""]  stringByReplacingOccurrencesOfString:@"a" withString:@""]];
                                                
                                            }
                                            if ( i == 10 ) {
                                                NSString *riskString = arrayRow[i];
                                                [arrayRisk addObject: [riskString stringByReplacingOccurrencesOfString:@"</td" withString:@""]];
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                    NSLog(@"arrayPlace  %@" , arrayPlace);
                                    NSLog(@"arrayBand  %@" , arrayBand);
                                    NSLog(@"arrayRisk  %@" , arrayRisk);
                                    
                                    [self.tableView setAlpha:1.0];
                                    [self.tableView reloadData];
                                    [self.activityIndicator stopAnimating];
                                    
                                });
        
        
                           }];
    [task resume];
}


//- (void)parser:(NSXMLParser *)parser
//didStartElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI
// qualifiedName:(NSString *)qualifiedName
//    attributes:(NSDictionary *)attributeDict {
//
//    //tblCurrAQHI_trHeader
//    if ([elementName isEqualToString:@"tr"]) {
//        if ( [attributeDict[@"class"] isEqualToString:@"tblCurrAQHI_trHeader"] ) {
//            parseHeader = YES;
//        }
//    }
//
//    if ([elementName isEqualToString:@"td"]) {
//        if ( [attributeDict[@"class"] isEqualToString:@"tblCurrAQHI_tdName"] ) {
//            NSLog(@"Open");
//            parserGapName = YES;
//        }
//
//        if ( [attributeDict[@"class"] isEqualToString:@"tblCurrAQHI_tdBand notSurrogate"] ) {
//            NSLog(@"Open");
//            parserGapBand = YES;
//        }
//        if ( [attributeDict[@"class"] isEqualToString:@"tblCurrAQHI_tdBand isSurrogate"] ) {
//            NSLog(@"Open");
//            parserGapBand = YES;
//        }
//
//        if ( [attributeDict[@"class"] isEqualToString:@"tblCurrAQHI_tdCate"] ) {
//            NSLog(@"Open");
//            parseGapRisk = YES;
//        }
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    if ( [string isEqualToString:@" "]) {
//        return;
//    }
//
//    if ( parseHeader ) {
//        [arrayHeader addObject:string];
//        NSLog(@"arrayHeader add : %@", string);
//    }
//
//    if ( parserGapName ) {
//        [arrayPlace addObject:string];
//        NSLog(@"arrayPlace add : %@", string);
//    }
//
//    if ( parserGapBand ) {
//        [arrayBand addObject:string];
//        NSLog(@"arrayBand add : %@", string);
//
//        parserGapBand = NO;
//    }
//
//    if ( parseGapRisk ) {
//        [arrayRisk addObject:string];
//        NSLog(@"arrayRisk add : %@", string);
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser
// didEndElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI
// qualifiedName:(NSString *)qName {
//    if ([elementName isEqualToString:@"tr"]) {
//
//        parseHeader = NO;
//
//    }
//
//    if ([elementName isEqualToString:@"td"]) {
//
//        parserGapName = NO;
//        parserGapBand = NO;
//        parseGapRisk = NO;
//
//    }
//}
//
//
//- (void)parserDidEndDocument:(NSXMLParser *)parser
//{
//    //NSLog(@"parserDidEndDocument %@ %@", arrayPlace, arrayBand);
//    [self.tableView reloadData];
//
//    if ( [arrayHeader count] >= 2) {
////        lblUpdateTime.text = arrayHeader[1];
//    }
//    [self.activityIndicator stopAnimating];
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSString*) translateToLocalized:(NSString*) str
{
    str = [str stringByReplacingOccurrencesOfString:@"<p>Roadside Stations: "  withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"Health Risk" withString:LString(@"Health Risk", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Low" withString:LString(@"Low", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Moderate" withString:LString(@"Moderate", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"High" withString:LString(@"High", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"to" withString:LString(@"to", nil)];
    return str;
}




#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        return 50;
    }
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    if ( [arrayPlace count] > 0 ) {
        return [arrayPlace count]+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"weatherCell";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    float widthView = self.tableView.frame.size.width;
    
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(13.0, 11.0, 200.0, 40.0)];
    UILabel *lblBand = [[UILabel alloc] initWithFrame:CGRectMake(widthView-120.0-20.0, 11.0, 40.0, 40.0)];
    UILabel *lblRisk = [[UILabel alloc] initWithFrame:CGRectMake(widthView-100.0, 11.0, 100.0, 40.0)];
    
    
    if ( indexPath.row == 0 ) {
        
        lblBand.frame = CGRectMake(widthView-120.0-40.0, 11.0, 40.0, 40.0);
//        lblRisk.frame = CGRectMake(230.0, 0, 100.0, 40.0);
        
        lblLeft.font = [UIFont fontWithName: @"BodoniSvtyTwoITCTT-Book" size:13.0];
        lblBand.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:15.0];
        if ( [urlString isEqualToString: kURL_aqhiXML_zh_hk] ) {
            lblRisk.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:15.0];
            
        } else {
            lblRisk.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:15.0];
            
        }
        
        
        lblRisk.textColor = [UIColor lightGrayColor];

        if ( [urlString isEqualToString: kURL_aqhiXML_zh_hk] ) {
            lblRisk.textAlignment = NSTextAlignmentCenter;
        }
        
        lblRisk.text = LString(@"Health Risk", nil);
        
        lblBand.text = LString(@"index", nil);
        
        
        
        [cell.contentView addSubview:lblLeft];
        [cell.contentView addSubview:lblBand];
        [cell.contentView addSubview:lblRisk];
        
        
    } else {
        //count++;

        
        lblLeft.font = [UIFont fontWithName: @"BodoniSvtyTwoITCTT-Book" size:23.0];
        lblBand.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:28.0];
        if ( [urlString isEqualToString: kURL_aqhiXML_zh_hk] ) {
            lblRisk.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:18.0];
            
        } else {
            lblRisk.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:18.0];
            
        }
        
        
        lblRisk.textColor = [UIColor lightGrayColor];
            
        lblLeft.text = LString(arrayPlace[indexPath.row-1], nil);
        lblBand.text = arrayBand[indexPath.row-1];
        lblRisk.text = LString(arrayRisk[indexPath.row-1], nil);
        

    
        if ( [urlString isEqualToString: kURL_aqhiXML_zh_hk] ) {
            lblRisk.textAlignment = NSTextAlignmentCenter;
        }
        
        
        [cell.contentView addSubview:lblLeft];
        [cell.contentView addSubview:lblBand];
        [cell.contentView addSubview:lblRisk];
        
    }
    
    
    
    return cell;
}







@end
