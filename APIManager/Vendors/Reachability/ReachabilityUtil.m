//
//  ReachabilityUtil.m
//  APIManager
//  https://www.linkedin.com/in/dinesh-saini-7a0b9781
//  Created by Dinesh Saini on 5/23/18.
//  Copyright © 2018 Dinesh Saini. All rights reserved.
//

#import "ReachabilityUtil.h"

@implementation ReachabilityUtil

+ (void)reachabilityWith:(void (^)(NetworkStatus ))status{
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = reach.currentReachabilityStatus;
    status(netStatus);
}


@end
