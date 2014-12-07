//
//  BGBroadCastController.m
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

#import "BGBroadcastController.h"
#import "BeaconGoInfo.h"

@interface BGBroadcastController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableView *_tableView;
}
@property (strong, nonatomic)NSArray *dataArray;
@end

@implementation BGBroadcastController
{
    UITextField  *_uuidTextField;
    UIPickerView *_uuidPicker;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self)
    {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        _uuid  = [BeaconGoInfo shareInfo].defaultProximityUUID;
        _power = [BeaconGoInfo shareInfo].defaultPower;
        
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Refresh the enabled switch.
    _enabled = _enabledSwitch.on = _peripheralManager.isAdvertising;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Configure";
    
    _enabledSwitch = [[UISwitch alloc] init];
    [_enabledSwitch addTarget:self action:@selector(configBeaconGo:) forControlEvents:UIControlEventValueChanged];
    
    _uuidPicker = [[UIPickerView alloc] init];
    _uuidPicker.delegate = self;
    _uuidPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uuidPicker.showsSelectionIndicator = YES;
    
    _uuidTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0f, 10.0f, 205.0f, 30.0f)];
    _uuidTextField.clearsOnBeginEditing = NO;
    _uuidTextField.textAlignment = NSTextAlignmentRight;
    _uuidTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uuidTextField.inputView = _uuidPicker;
    _uuidTextField.delegate = self;
    
    _majorTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 10.0f, 185.0f, 30.0f)];
    _majorTextField.clearsOnBeginEditing = NO;
    _majorTextField.textAlignment = NSTextAlignmentRight;
    _majorTextField.keyboardType = UIKeyboardTypeNumberPad;
    _majorTextField.returnKeyType = UIReturnKeyDone;
    _majorTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _majorTextField.delegate = self;
    _majorTextField.text = @"0";
    _minorTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 10.0f, 185.0f, 30.0f)];
    _minorTextField.clearsOnBeginEditing = NO;
    _minorTextField.textAlignment = NSTextAlignmentRight;
    _minorTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minorTextField.returnKeyType = UIReturnKeyDone;
    _minorTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _minorTextField.delegate = self;
    _minorTextField.text = @"0";
    _powerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 10.0f, 185.0f, 30.0f)];
    _powerTextField.clearsOnBeginEditing = NO;
    _powerTextField.textAlignment = NSTextAlignmentRight;
    _powerTextField.keyboardType = UIKeyboardTypeNumberPad;
    _powerTextField.returnKeyType = UIReturnKeyDone;
    _powerTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _powerTextField.delegate = self;
    
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(configBeaconGo:)];
    _saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(configBeaconGo:)];
    self.navigationItem.rightBarButtonItem = _saveButton;
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Configure Device";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    switch(indexPath.row)
    {
        case 0:
        {
            // Enabled
            cell.textLabel.text = @"Enabled";
            cell.accessoryView = _enabledSwitch;
            break;
        }
            
        case 1:
        {
            // Proximity UUID
            cell.textLabel.text = @"UUID";
            _uuidTextField.text = [_uuid UUIDString];
            [cell.contentView addSubview:_uuidTextField];
            break;
        }
            
        case 2:
        {
            // Major
            cell.textLabel.text = @"Major";
            _majorTextField.text = [_major stringValue];
            if ([_major stringValue] == nil) {
                _majorTextField.text = @"0";
            }
            [cell.contentView addSubview:_majorTextField];
            break;
        }
            
        case 3:
        {
            // Minor
            cell.textLabel.text = @"Minor";
            _minorTextField.text = [_minor stringValue];
            if ([_minor stringValue] == nil) {
                _minorTextField.text = @"0";
            }
            [cell.contentView addSubview:_minorTextField];
            break;
        }
            
        case 4:
        {
            // Measured Power
            cell.textLabel.text = @"Measured Power";
            _powerTextField.text = [_power stringValue];
            [cell.contentView addSubview:_powerTextField];
            break;
        }
            
        default:
        {
            break;
        }
    }
    return cell;
}

#pragma mark - UIPicker Delagate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _uuidPicker)
    {
        return [BeaconGoInfo shareInfo].supportedProximityUUIDs.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(pickerView == _uuidPicker)
    {
        UILabel *label = (UILabel *)view;
        if(!label)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60.0f)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
        }
        
        label.text = [[[BeaconGoInfo shareInfo].supportedProximityUUIDs objectAtIndex:row] UUIDString];
        
        return label;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == _uuidPicker)
    {
        _uuid = [[BeaconGoInfo shareInfo].supportedProximityUUIDs objectAtIndex:row];
        _uuidTextField.text = [_uuid UUIDString];
    }
}

#pragma mark - TextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = _doneButton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _majorTextField)
    {
        _major = [_numberFormatter numberFromString:textField.text];
    }
    else if(textField == _minorTextField)
    {
        _minor = [_numberFormatter numberFromString:textField.text];
    }
    else if(textField == _powerTextField)
    {
        _power = [_numberFormatter numberFromString:textField.text];
    }
    
    self.navigationItem.rightBarButtonItem = _saveButton;
}

#pragma mark - CBPeripheralManager delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // The implementation of this delegate method is required, although we're not really doing anything with it
}

#pragma mark - Config Advertising Settings

- (void)configBeaconGo:(id)sender
{
    if(sender == _enabledSwitch)
    {
        _enabled = _enabledSwitch.on;
    }
    else if(sender == _doneButton)
    {
        [_uuidTextField resignFirstResponder];
        [_majorTextField resignFirstResponder];
        [_minorTextField resignFirstResponder];
        [_powerTextField resignFirstResponder];
        
        [self.tableView reloadData];
    }
    else if(sender == _saveButton)
    {
        if(_peripheralManager.state < CBPeripheralManagerStatePoweredOn)
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth must be enabled" message:@"To configure your device as a beacon" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            
            return;
        }
        
        if(_enabled)
        {
            // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
            NSDictionary *peripheralData = nil;
            if(_uuid && _major && _minor)
            {
                _region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:[_major shortValue] minor:[_minor shortValue] identifier:@"com.ondemandworld.BeaconGo"];
                peripheralData = [_region peripheralDataWithMeasuredPower:_power];
            }
            else if(_uuid && _major)
            {
                _region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:[_major shortValue]  identifier:@"com.ondemandworld.BeaconGo"];
                peripheralData = [_region peripheralDataWithMeasuredPower:_power];
            }
            else if(_uuid)
            {
                _region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"com.ondemandworld.BeaconGo"];
                peripheralData = [_region peripheralDataWithMeasuredPower:_power];
            }
            
            // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
            if(peripheralData)
            {
                [_peripheralManager startAdvertising:peripheralData];
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth" message:@"Configure this iOS device as a beacon successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];

            }
        }
        else
        {
            [_peripheralManager stopAdvertising];
        }
        
    }
}
@end
