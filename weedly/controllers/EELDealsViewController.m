//
//  EELDealsViewController.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDealsViewController.h"

@interface EELDealsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshToggle;

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

    // load the deals page
    [self loadExternalPage:@"https://weedmaps.com/deals?device=iphone&width=320px&lat=0.000000&lon=0.000000"];
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
