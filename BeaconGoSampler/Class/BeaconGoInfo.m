//
//  BeaconGoInfo.m
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

#import "BeaconGoInfo.h"

@implementation BeaconGoInfo

static BeaconGoInfo *info = nil;
- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"59B7AD83-8669-477A-B91A-AAD4660397D6"],
                                     [[NSUUID alloc] initWithUUIDString:@"F4A8E6C2-2CDE-4037-BF81-A03D29C8B6A8"],
                                     [[NSUUID alloc] initWithUUIDString:@"D6CCC943-6F43-4AC6-8EB6-118C79DD321C"],
                                     [[NSUUID alloc] initWithUUIDString:@"5088324D-031B-4F89-9F8B-AE83C42AC5D4"],
                                     [[NSUUID alloc] initWithUUIDString:@"C03E8DFC-CA7D-4890-849A-257673EF2AC2"],
                                     [[NSUUID alloc] initWithUUIDString:@"D7B5051B-B8B8-492F-A6A2-A78E10A22245"],
                                     [[NSUUID alloc] initWithUUIDString:@"C02862D7-9C01-4C2E-9EAB-8B1B46B89E7A"],
                                     [[NSUUID alloc] initWithUUIDString:@"A9D5B1E5-A99B-4C9D-8D0D-12D8B4AD3C69"],
                                     [[NSUUID alloc] initWithUUIDString:@"4C0BEF50-0F23-4142-A7C9-7260A7BB13F3"],
                                     [[NSUUID alloc] initWithUUIDString:@"298B5067-C41B-4676-84FF-12F63957FD8F"],
                                     [[NSUUID alloc] initWithUUIDString:@"E6BF275E-0BB3-43E5-BF88-517F13A5A162"],
                                     ];
        _defaultPower = @-59;
    }
    
    return self;
}

+(BeaconGoInfo *)shareInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[BeaconGoInfo alloc]init];
    });
    return info;
}

- (NSUUID *)defaultProximityUUID
{
    return [_supportedProximityUUIDs objectAtIndex:0];
}

@end
