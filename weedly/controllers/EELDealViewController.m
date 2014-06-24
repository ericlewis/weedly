//
//  EELDealViewController.m
//  weedly
//
//  Created by 1debit on 6/24/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDealViewController.h"

@interface EELDealViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) EELDispensary *dispensary;

@end

@implementation EELDealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Deals";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://weedmaps.com/dispensaries/%@/deals/420", self.dispensary.id.stringValue]]]];
}

- (void)loadDealsWithDispensary:(EELDispensary *)dispensary{
    _dispensary = dispensary;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
