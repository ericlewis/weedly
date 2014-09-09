//
//  EELStrainInfoViewController.h
//  weedly
//
//  Created by Eric Lewis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELStrainInfoViewController : UIViewController<UIWebViewDelegate>

- (void)loadInfoWithStrain:(EELStrain *)strain;
- (void)loadInfoWithURL:(NSURL *)url andName:(NSString*)name;

@end
