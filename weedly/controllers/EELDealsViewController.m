//
//  EELDealsViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDealsViewController.h"

@interface EELDealsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshToggle;

@property (nonatomic, strong) NSArray* deals;

@end

@implementation EELDealsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[EELWMClient sharedClient] getDealsAround:[MTLocationManager sharedInstance].lastKnownLocation limit:10 completionBlock:^(NSArray* results, NSError* error) {
        if (error) //do... something... idk
            return;
        self.deals = results;
        //now do something with the deals
    }];

    // load the deals page
    CLLocationCoordinate2D coords = [MTLocationManager sharedInstance].lastKnownLocation.coordinate;
    
    [self loadExternalPage:[NSString stringWithFormat:@"https://weedmaps.com/deals?device=iphone&width=320px&lat=%f&lon=%f", coords.latitude, coords.longitude]];
    
    self.navigationController.toolbarHidden = YES;
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma UIWebView Delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	NSLog(@"[UIWebViewController] Load failed: %@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)view{
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

#pragma mark Actions

- (void)loadExternalPage:(NSString*)urlAddress {
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
}

@end
