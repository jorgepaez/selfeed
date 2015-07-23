//
//  ViewController.m
//  Selfeed
//
//  Created by Jorge Paez on 7/23/15.
//  Copyright (c) 2015 Jorge Paez. All rights reserved.
//

#import "ViewController.h"

__weak ViewController* refSelf;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    refSelf = self;
    [[WSHandler sharedInstance] setDelegateVC:self];
    [[WSHandler sharedInstance] sessionUsingUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/v1/tags/selfie/media/recent?client_id=%@",API_DOMAIN, API_CLIENT_ID]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertMessage:(NSString*)text {
    //gets on the main queue so it can show the alert
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}

- (BOOL)array:(NSArray*)array containsString:(NSString*)text{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",[NSString stringWithFormat:@"%@",text]];
    NSArray *hasString = [array filteredArrayUsingPredicate:predicate];
    if ([hasString count] > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - override of getters and setters

@synthesize imagesSource = _imagesSource;
- (void)setImagesSource:(NSArray *)imagesSource {
    dispatch_async(dispatch_get_main_queue(), ^{
        _imagesSource = imagesSource;
        [refSelf setSelectedCellIndex:-1];//no cell is selected at the moment
        [[refSelf imagesCollectionView] reloadData];
    });
}

#pragma mark FlowLayout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //we ensure the array doesn't get out of bounds with "%" so if infinite scroll is implemented there's always content to display
    NSInteger index = [indexPath row];
    NSMutableDictionary *dictImage = [[self imagesSource] objectAtIndex:index%[[self imagesSource] count]];
    if (index == [self selectedCellIndex]) {
        //320 is a sutable big size
        return CGSizeMake(320, 320);
    } else {
        CGFloat minSize = 50;
        CGFloat factor = 0.25; //0.25 because images are too big
        return CGSizeMake(MAX([[dictImage objectForKey:@"width"] integerValue]*factor,minSize), MAX([[dictImage objectForKey:@"height"] integerValue]*factor,minSize));
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //20 is a sutable margin
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark - CollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self selectedCellIndex]==[indexPath row]) {
        //if it is already selected, return it to its size
        [self setSelectedCellIndex:-1];
    }else{
        [self setSelectedCellIndex:[indexPath row]];
    }
    //do animation
    [collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] animated:YES];
    [[[self imagesCollectionView] collectionViewLayout] invalidateLayout];
}

#pragma mark - WSHandler delegate

- (void)didFinishDownloadingJson:(NSDictionary*)json{
    NSLog(@"json:\n%@", json);
    if ([json[@"meta"][@"code"] integerValue] != 200) {
        [self showAlertMessage:@"Error: status code is not ok"];
        return;
    }
    NSMutableArray* dictImages = [NSMutableArray new];
    int orderSize = 0; //counter to order images by big,small,small (repeat)
    for (NSDictionary *user in json[@"data"]) {
        NSDictionary *images = [user objectForKey:@"images"];
        if (orderSize % 3 == 0) { //if 0 use big image
            [dictImages addObject:[NSMutableDictionary dictionaryWithDictionary:[images objectForKey:@"standard_resolution"]]];
        }else{ //use small image
            [dictImages addObject:[NSMutableDictionary dictionaryWithDictionary:[images objectForKey:@"low_resolution"]]];
        }
        orderSize++;
    }
    [self setImagesSource:dictImages];
}

- (void)didFailDownloadingJson:(NSString*)error{
    [self showAlertMessage:error];
}

#pragma mark DataSource delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self imagesSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellImage" forIndexPath:indexPath];
    __weak NSMutableDictionary* dictImage= [[self imagesSource] objectAtIndex:[indexPath row]%[[self imagesSource] count]];
    //we use tags so we can retrive the actual imageView object and we don't need a custom class cell with the UIImageView IBOutlet property
    CustomImageView *imageView = (CustomImageView *)[cell viewWithTag:28];
    [imageView setImageFromDictionary:dictImage];
    return cell;
}

@end