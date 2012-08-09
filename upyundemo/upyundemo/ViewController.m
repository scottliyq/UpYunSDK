//
//  ViewController.m
//  upyundemo
//
//  Created by andy yao on 12-6-14.
//  Copyright (c) 2012年 upyun.com. All rights reserved.
//

#import "ViewController.h"
#import "UpYun.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize image,pv;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (int)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year=[comps year]; 
    return year;
}

- (int)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps month];
    return month;
}

- (IBAction)uploadImage:(id)sender {
    UpYun *uy = [UpYun sharedClient];
    uy.delegate = self;
    uy.expiresIn = 100;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:@"0,1000" forKey:@"content-length-range"];
//    [params setObject:@"png" forKey:@"allow-file-type"];
    uy.params = params;
    NSDate *d = [NSDate date];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* img = [resourcePath stringByAppendingPathComponent:@"LInKb.jpg"];
    [uy uploadImagePath:img savekey:[NSString stringWithFormat:@"/scott001/%@.jpq", [uy generateRandomString]]];
}

- (void)upYun:(UpYun *)upYun requestDidFailWithError:(NSError *)error {
    NSString *string = [error.userInfo objectForKey:@"message"];
    if ([ERROR_DOMAIN isEqualToString:error.domain]) {
        string = [error.userInfo objectForKey:@"message"];
    } else {
        string = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string 
                                                    message:nil 
                                                   delegate:nil 
                                          cancelButtonTitle:@"关闭" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)upYun:(UpYun *)upYun requestDidSendBytes:(long long)bytes progress:(float)progress {
    [self.pv setProgress:progress];
}

- (void)upYun:(UpYun *)upYun requestDidSucceedWithResult:(id)result {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传成功" 
                                                    message:nil 
                                                   delegate:nil 
                                          cancelButtonTitle:@"关闭" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
@end
