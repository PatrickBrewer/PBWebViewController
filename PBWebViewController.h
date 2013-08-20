//
//  PBWebViewController.h
//  
//
//  Created by Patrick W Brewer on 1/6/13.
//  Modified to publish on github on 8/13/13.
//

#import <UIKit/UIKit.h>


@interface PBWebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
    NSString *url;
    UIBarButtonItem *returnButton;
    UIBarButtonItem *forwardButton;
    NSInteger count;
    NSTimer *checkTimer;
    BOOL viewDisappearing;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *url;

- (id) init;
- (id) initWithURL: (NSString *)initUrl;


@end
