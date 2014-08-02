/* Copyright (c) 8/1/14, Ryan Dignard
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

#import "EELYLocationManager.h"

NSString* const kEELYLocationStatusDidChange = @"LocationStatusDidChange";
NSString* const kEELYLocationDidChange = @"LocationDidChange";

@interface EELYLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong, readwrite) CLLocation* location;
@property (nonatomic, assign, readwrite) CLAuthorizationStatus status;
@end

@implementation EELYLocationManager

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static id _sSharedManaged;
    dispatch_once(&onceToken, ^{
        _sSharedManaged = [[self alloc] init];
        [_sSharedManaged setDelegate:_sSharedManaged];
    });
    return _sSharedManaged;
}

static CLLocation* _sLocation;
- (CLLocation*) location {
    return _sLocation;
}

- (void) setLocation:(CLLocation*)location {
    if (location) {
        _sLocation = location;
    }
}

- (void) locationManager:(CLLocationManager*)manager
      didUpdateLocations:(NSArray*)locations {
    self.location = [locations lastObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)kEELYLocationDidChange object:nil];
}

- (void) locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    self.status = status;
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)kEELYLocationStatusDidChange object:nil];
}

@end
