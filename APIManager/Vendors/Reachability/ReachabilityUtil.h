//
//  ReachabilityUtil.h
//  APIManager
//  https://www.linkedin.com/in/dinesh-saini-7a0b9781
//  Created by Dinesh Saini on 5/23/18.
//  Copyright © 2018 Dinesh Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityUtil : NSObject
+ (void)reachabilityWith:(void (^)(NetworkStatus ))status;
@end
