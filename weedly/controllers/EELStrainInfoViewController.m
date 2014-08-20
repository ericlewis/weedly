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
@property (nonatomic) BOOL loaded;
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
    
    NSString* css = @"\"#dispensaries, #global-header, .azk-block, .leafly-social-mobile, #banner-nav, #reviews, #photos, #genetics, #similar-strains, #articles, footer {display:none;} \"";
    NSString* js = [NSString stringWithFormat:
                    @"var styleNode = document.createElement('style');\n"
                    "styleNode.type = \"text/css\";\n"
                    "var styleText = document.createTextNode(%@);\n"
                    "styleNode.appendChild(styleText);\n"
                    "document.getElementsByTagName('head')[0].appendChild(styleNode);\n",css];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    _loaded = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (_loaded) {
        return NO;
    }
    
    return YES;
}


@end
