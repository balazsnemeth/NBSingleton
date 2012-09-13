//
//  ConnectionChecking.m
//
//  Created by Németh Balázs on 6/26/12.
//

#import "ConnectionChecking.h"
#import "Reachability.h"

@interface ConnectionChecking()
   @property(strong,nonatomic) NSTimer* connectionCheckTimer;
    -(void) checkConnection;
@end

@implementation ConnectionChecking

@synthesize connectionCheckTimer;

static ConnectionChecking *sharedConnectionChecking = nil;

+ (ConnectionChecking *)sharedConnectionChecking
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnectionChecking = [[ConnectionChecking alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedConnectionChecking;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedConnectionChecking == nil) {
            sharedConnectionChecking = [super allocWithZone:zone];
            return sharedConnectionChecking;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}


+ (id)alloc {
    @synchronized(self) {
        if (sharedConnectionChecking == nil) {
            sharedConnectionChecking = [super alloc];
            return sharedConnectionChecking;  // assignment and return on first allocation
        }
    }
    return sharedConnectionChecking; // on subsequent allocation attempts return nil
}
//The real class function!

- (void) startCheckingNetwork{
    [self stopCheckingNetwork];
    connectionCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkConnection) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:connectionCheckTimer forMode:NSDefaultRunLoopMode];
}

- (void) stopCheckingNetwork{
    if(connectionCheckTimer != nil){
        [connectionCheckTimer invalidate];
        connectionCheckTimer = nil;
    }
}


-(void) checkConnection{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    //[reachability setHostName:serverURL];    // set your host name here
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    BOOL internetActive = FALSE;
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Az adatbázis nem elérhető" message: @"Kérjük ellenőrizze a hálózatot" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            internetActive = YES;
            
            break;
            
        }
    }
}

@end
