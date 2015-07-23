//
//  WSHandler.h
//  Selfeed
//
//  Created by Jorge Paez on 7/23/15.
//  Copyright (c) 2015 Jorge Paez. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonDonwloadParser <NSObject>

@required
-(void)didFinishDownloadingJson:(NSDictionary *)json;

@optional
-(void)didFailDownloadingJson:(NSString *)error;

@end

@interface WSHandler : NSObject

@property (nonatomic,weak) id <JsonDonwloadParser> delegateVC;

-(void)sessionUsingUrl:(NSURL*)url;
+ (WSHandler *)sharedInstance;

@end
