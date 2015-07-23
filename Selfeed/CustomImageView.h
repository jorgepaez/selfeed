//
//  CustomImageView.h
//  Selfeed
//
//  Created by Jorge Paez on 7/23/15.
//  Copyright (c) 2015 Jorge Paez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageView : UIImageView

@property (nonatomic, strong) NSString *url;

- (void)setImageFromDictionary:(__weak NSMutableDictionary*)imageDict;

@end