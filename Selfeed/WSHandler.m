//
//  WSHandler.m
//  Selfeed
//
//  Created by Jorge Paez on 7/23/15.
//  Copyright (c) 2015 Jorge Paez. All rights reserved.
//

#import "WSHandler.h"

static WSHandler *sharedInstance;

@implementation WSHandler

+ (WSHandler *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[WSHandler alloc] init];
    }
    return sharedInstance;
}

-(void)sessionUsingUrl:(NSURL*)url{
    __weak WSHandler *weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //in case of error
        if (error || response == nil || data.length==0) {
            [[weakSelf delegateVC] didFailDownloadingJson:@"Error: Check internet connection"];
        }else{
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
            [[weakSelf delegateVC] didFinishDownloadingJson:json];
        }
    }];
    [task resume];
}

@end
