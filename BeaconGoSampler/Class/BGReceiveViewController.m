//
//  BGReceiveViewController.m
//  BeaconGoSampler
//
//  Copyright (c) 2014 OnDemandWorld http://www.OnDemandWorld.com
//  
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//  
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.//

#import "BGReceiveViewController.h"
#import "BeaconGoInfo.h"

@interface BGReceiveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation BGReceiveViewController

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
    [self createBeaconGoTableView];
    self.detectedBeacons = [NSMutableArray array];
    self.existUUIDs      = [NSMutableSet set];
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate=self;
    
    /* iOS 8  To ask system for location service permission*/
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    [self setUpRangingBeaconGo];
}

#pragma mark - Set up BeaconGo

- (void)setUpRangingBeaconGo
{
    [[BeaconGoInfo shareInfo].supportedProximityUUIDs enumerateObjectsUsingBlock:^(id uuidObj, NSUInteger uuidIdx, BOOL *uuidStop) {
        NSUUID *uuid = (NSUUID *)uuidObj;
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        /*You should use following to test Background Event*/
        //region.notifyOnEntry = YES;
        //region.notifyOnExit  = YES;
        region.notifyEntryStateOnDisplay=YES;
        /*You should use startRangingBeaconsInRegion in this case*/
        [_locationManager startRangingBeaconsInRegion:region];
    }];
}

#pragma mark - CLLocationManager Delegate method

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Start Monitoring");
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        /* Beacon found */
        
        for (int j = 0; j < [beacons count]; j ++)
        {
            
            if (self.detectedBeacons.count)
            {
                
                for (int i = 0 ; i < [self.detectedBeacons count]; i++)
                {
                    
                    if ( [self.existUUIDs containsObject:[[beacons objectAtIndex:j] proximityUUID]])
                    {
                        if ([[[self.detectedBeacons objectAtIndex:i] proximityUUID] isEqual:[[beacons objectAtIndex:j] proximityUUID]])
                        {
                            [self.detectedBeacons replaceObjectAtIndex:i withObject:[beacons objectAtIndex:j]];
                            break;
                        }
                    }
                    else
                    {
                        [self.detectedBeacons addObject:[beacons objectAtIndex:j]];
                        [self.existUUIDs addObject:[[beacons objectAtIndex:j] proximityUUID]];

                        break;
                        
                    }
                    
                }
                
            }
            else
            {
                [self.detectedBeacons addObject:[beacons objectAtIndex:j]];
                [self.existUUIDs addObject:[[beacons objectAtIndex:j] proximityUUID]];

            }
        }
 
        [_tableView reloadData];
    }else{
        /* No beacon found */
    }
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entry a Beacon region");
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exit a Beacon region");
}

-(void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Fail ranging beacon");
}

#pragma mark - BeaconGo TableView
-(void)createBeaconGoTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detectedBeacons.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    CLBeacon *beacon = [self.detectedBeacons objectAtIndex:indexPath.row];
    _uuidStr=[beacon.proximityUUID UUIDString];
    _major  =[beacon.major stringValue];
    _minor  =[beacon.minor stringValue];
    _rssi   =[NSString stringWithFormat:@"%ld",(long)beacon.rssi];
    _prx    =[NSString stringWithFormat:@"%f",beacon.accuracy];

    cell.textLabel.text       = [NSString stringWithFormat:@"UUID:%@",_uuidStr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"major:%@  minor:%@  rssi:%@  prx:%@",_major,_minor,_rssi,_prx];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:8]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
