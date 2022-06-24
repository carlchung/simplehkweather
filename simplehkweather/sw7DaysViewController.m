//
//  sw7DaysViewController.m
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//cannot attach to process due to System Integrity Protection

#import "swAppDelegate.h"
#import "sw7DaysViewController.h"
#define kRSS_URL_SeveralDays @"http://rss.weather.gov.hk/rss/SeveralDaysWeatherForecast.xml"

// 7.0 and above
#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)

// 6.0, 6.0.x, 6.1, 6.1.x
#define IS_DEVICE_RUNNING_IOS_6_OR_BELOW() ([[[UIDevice currentDevice] systemVersion] compare:@"6.2" options:NSNumericSearch] != NSOrderedDescending)

@interface sw7DaysViewController ()

@end

@implementation sw7DaysViewController

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

    
    
    count = 0;
    arrayContent = [NSArray arrayWithObject:@""];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    swAppDelegate* appDelegate = (swAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    fontName = [appDelegate customFontName];
    
    [self load7daysForecast];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView setAlpha:0.0];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(self.tableView.frame.size.width/2+15, 25, 30, 30);
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    //self.tabBarItem.title = LString(@"M_7DAYS", nil);
}

- (void) load7daysForecast
{
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kRSS_URL_SeveralDays]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10.0];
    
    // create the connection with the request
    // and start loading the data
    // note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                               
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                    
                    //dataString = @"<item> <title><![CDATA[Strong Wind Signal (01:03 HKT 04/02/2014)  ]]></title><link>http://www.weather.gov.hk/textonly/warning/warn.htm</link><author>Hong Kong Observatory</author><description><![CDATA[Strong Wind Signal]]></description> <pubDate>Tue, 04 Feb 2014 01:03:20 +0800</pubDate><guid isPermaLink=\"false\">http://rss.weather.gov.hk/rss/1391447000/nowarning</guid></item><item> <title><![CDATA[Red Rainstorm Warning Signal (01:03 HKT 04/02/2014)  ]]></title><link>http://www.weather.gov.hk/textonly/warning/warn.htm</link><author>Hong Kong Observatory</author><description><![CDATA[Red Rainstorm Warning Signal]]></description> <pubDate>Tue, 04 Feb 2014 01:03:20 +0800</pubDate><guid isPermaLink=\"false\">http://rss.weather.gov.hk/rss/1391447000/nowarning</guid></item>";
                    
                    NSLog(@"dataString:\n%@",dataString);
                    if ( error ) {
                        // inform the user
//                        UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"Connection failed! " message: @""  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//                        [didFailWithErrorMessage show];
                        UIAlertController * alert = [UIAlertController
                                                      alertControllerWithTitle:@"Connection failed! "
                                                      message:@""
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            //do something when click button
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                        //inform the user
                        NSLog(@"Connection failed! Error - %@ %@",
                              [error localizedDescription],
                              [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
                    }
                    arrayContent = [dataString componentsSeparatedByString:@"Date/Month:"];
                    [self.tableView setAlpha:1.0];
                    [self.tableView reloadData];
                    [myPTR isDoneRefreshing];
                    
                    [self.activityIndicator stopAnimating];
                });
            }];
    [task resume];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self load7daysForecast];
    [refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
}
- (NSString*) detectWeatherType: (NSString*) desc
{
    NSRange rangeType;
    NSLog(@"Desc %@", desc);
    
    rangeType = [desc rangeOfString:@"rain" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        
        rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        return  @"desc rain";
    }
    
    rangeType = [desc rangeOfString:@"shower" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        
        rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        
        return  @"desc shower";
    }
    rangeType = [desc rangeOfString:@"cloudy" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc sunny interval";
        }
        rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc sunny interval";
        }
        return  @"desc cloudy";
    }
    rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"brightintervals" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"brightperiods" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    
    rangeType = [desc rangeOfString:@"fine" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc fine";
    }
    rangeType = [desc rangeOfString:@"sunny" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny";
    }
    
    rangeType = [desc rangeOfString:@"thunderstorm" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc thunderstorm";
    }
    
    
    
    return @"";
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [arrayContent count]>=1 ) {
        if ( indexPath.row == 0 ) {
            return 20;
        }
        return 85;
    } else {
        return 85;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    if ( [arrayContent count]>=1 ) {
        return [arrayContent count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"weatherCell";
    //UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell;
    //if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    //}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    if ( indexPath.row == 0 ) {
        
        
    } else {
        //count++;
        NSLog(@"arrayContent %@", [arrayContent objectAtIndex:indexPath.row]);
        NSString *cellWholeStringInLines = [arrayContent objectAtIndex:indexPath.row];
        NSString *cellWholeString = [[cellWholeStringInLines componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];

        NSArray *arrayItems = [cellWholeString componentsSeparatedByString:@"<br/>"];
        
        //NSLog(@"items %i %@", indexPath.row, arrayItems);

        
        float widthView = self.tableView.frame.size.width;
        UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(13.0, 21.0, 150.0, 40.0)];
        UILabel *lblRight = [[UILabel alloc] initWithFrame:CGRectMake(widthView-120.0, 21.0, 140.0, 40.0)];
        
        lblLeft.font = [UIFont fontWithName: @"BodoniSvtyTwoITCTT-Book" size:27.0];
        lblRight.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:32.0];
        
        
        lblLeft.textColor = [UIColor lightGrayColor];
        if ( [arrayItems count] >= 4 ) {
            
            lblLeft.text = [self translateToLocalized:[arrayItems objectAtIndex:0]];
            lblRight.text =  [self translateToLocalized: [arrayItems objectAtIndex:3]];
        }
        
        NSString *strForecast = [self translateToLocalized:[arrayItems objectAtIndex:2]] ;
        NSLog(@" strForecast %@", strForecast);
        UIImage *imageWeather;
        if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc rain"] ) {
            imageWeather = [UIImage imageNamed:@"rain.png"];
        } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc shower"]  ) {
            imageWeather = [UIImage imageNamed:@"rain_sunny.png"];
        } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc showerWithSun"]  ) {
            imageWeather = [UIImage imageNamed:@"rain_sunny.png"];
            
        } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc cloudy"]  ) {
            imageWeather = [UIImage imageNamed:@"cloudy.png"];
        } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny interval"]  ) {
            imageWeather = [UIImage imageNamed:@"sunnyperiod.png"];
            
        } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc fine"]  ) {
            imageWeather = [UIImage imageNamed:@"sunny.png"];
        } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny"]  ) {
            imageWeather = [UIImage imageNamed:@"sunny.png"];
        } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc thunderstorm"]  ) {
            imageWeather = [UIImage imageNamed:@"thunder.png"];
        }
        
        UIImageView *imageWeatherView = [[UIImageView alloc] initWithFrame:CGRectMake(widthView/2-30.0, 18, 75, 50)];
        imageWeatherView.image = imageWeather;
        [cell.contentView addSubview:imageWeatherView];
        
        [cell.contentView addSubview:lblLeft];
        [cell.contentView addSubview:lblRight];
    }
    
    
    
    return cell;
}


- (NSString*) translateToLocalized:(NSString*) str
{
    str = [str stringByReplacingOccurrencesOfString:@" C"  withString:@"°"];
    str = [str stringByReplacingOccurrencesOfString:@" -"  withString:@"° "];

    str = [str stringByReplacingOccurrencesOfString:@"\t"  withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n"  withString:@""];

    str = [str stringByReplacingOccurrencesOfString:@"Weather:" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"Temp range:" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"Monday" withString:LString(@"Monday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Tuesday" withString:LString(@"Tuesday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Wednesday" withString:LString(@"Wednesday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Thursday" withString:LString(@"Thursday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Friday" withString:LString(@"Friday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Saturday" withString:LString(@"Saturday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Sunday" withString:LString(@"Sunday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@" "  withString:@""];
    return str;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
