//
//  ConnectionChecking.h
//
//  Created by Németh Balázs on 6/26/12.
//

#import <Foundation/Foundation.h>

@interface ConnectionChecking : NSObject

+ (ConnectionChecking *)sharedConnectionChecking;

- (void) startCheckingNetwork;
- (void) stopCheckingNetwork;

@end
