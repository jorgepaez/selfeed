//
//  ViewController.h
//  Selfeed
//
//  Created by Jorge Paez on 7/23/15.
//  Copyright (c) 2015 Jorge Paez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+UrlEncoding.h"
#import "WSHandler.h"
#import "CustomImageView.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JsonDonwloadParser>


@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (strong, nonatomic) NSArray* imagesSource;
@property (nonatomic, assign) NSInteger selectedCellIndex;

@end