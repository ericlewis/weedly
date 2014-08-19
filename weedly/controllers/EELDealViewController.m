//
//  EELDealViewController.m
//  weedly
//
//  Created by Eric Lewis on 6/24/14.
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
    
    [UAAppReviewManager userDidSignificantEvent:YES];
}

- (void)loadDealsWithDispensary:(EELDispensary *)dispensary{
    _dispensary = dispensary;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString* css = @"\"body { background-color: #FFFFFF;} .wm-listing-bordered-section { min-height: 0; margin: 0 0 15px 0; } .wm-listing-bordered-section-header { background-color: #fafafa; color: black; } .deal-empty, .deal-empty span { background-color: #FFFFFF; color: #000000; } \"";
    NSString* js = [NSString stringWithFormat:
                    @"var styleNode = document.createElement('style');\n"
                    "styleNode.type = \"text/css\";\n"
                    "var styleText = document.createTextNode(%@);\n"
                    "styleNode.appendChild(styleText);\n"
                    "document.getElementsByTagName('head')[0].appendChild(styleNode);\n"
                    "document.getElementsByTagName('img')[0].remove();\n",css];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
