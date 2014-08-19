//
//  EELStrainInfoViewController.m
//  weedly
//
//  Created by Eric Lewis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELStrainInfoViewController.h"

@interface EELStrainInfoViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) EELStrain *strain;
@end

@implementation EELStrainInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.strain.name;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.leafly.com/%@/%@", self.strain.category.lowercaseString, self.strain.slug]]]];
    
    [UAAppReviewManager userDidSignificantEvent:YES];
}

- (void)loadInfoWithStrain:(EELStrain *)strain{
    _strain = strain;
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
