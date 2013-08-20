//
//  PBWebViewController.m
//
//  Created by Patrick W Brewer on 1/6/13.
//  Modified to publish on github on 8/13/13.
//
//

#import "PBWebViewController.h"

@interface PBWebViewController ()

@end

@implementation PBWebViewController

@synthesize webView, url;


- (id) initWithURL:(NSString *)initUrl
{
    self = [super init];
    if (self) {
        url = initUrl;
        checkTimer = nil;
        viewDisappearing = NO; 
    }
    return self;
}

- (id) init
{
   return [self initWithURL:@"http://google.com/"];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.webView.delegate = self; // setup the delegate as the web view is shown
}


- (void)viewWillDisappear:(BOOL)animated
{   // in case the web view is still loading its content
    [self.webView stopLoading];
    
    viewDisappearing = YES; 
    // disconnect the delegate as the webview is hidden
    self.webView.delegate = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //self.title=@"Tweets";
    CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
    webFrame.origin.y -= 20;
    //webFrame.size.height -= 40.0;
    
    self.webView = [[UIWebView alloc] initWithFrame:webFrame];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.delegate = self;

    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self becomeFirstResponder];
}


- (void) startTimer {
    if (checkTimer != nil){
        [checkTimer invalidate];
        checkTimer = nil;
    }
    
    checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerCall:) userInfo:nil repeats:YES];
    count = 2;
    //NSLog(@"PB startTimer called");
}


- (BOOL) canBecomeFirstResponder {
    return YES;
}


- (BOOL) canResignFirstResponder {
    // This gets called every time there is a UI event in the view as long
    // as this object is the FirstResponder.
    
    //NSLog(@"canResignFirstResponder called");
    if ( [self isBeingDismissed]  || viewDisappearing ) {
        [checkTimer invalidate];
        return YES;
    }
    // If view is going away give up FirstResponder, else start the timer and keep it.
    [self startTimer];
    return NO;
}

- (void) timerCall: (id) t
{
    NSTimer *aTimer = (NSTimer *) t;
    // Check the button statuses
    [self checkButtonStatus];
    count--;
    
    // Check to see if we should invalidate the timer.
    if (count < 1) {
        [aTimer invalidate];
        checkTimer = nil; 
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];

}


- (BOOL) webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (view != self.webView) {
        NSLog(@"unexpected that webView doesn't equal my webview");
    }
    return YES; 
}


- (void)webViewDidStartLoad:(UIWebView *)view
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)view
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (returnButton == nil) {
        [self createAndAddButtons];
    }
}


- (void)webView:(UIWebView *)view didFailLoadWithError:(NSError *)error
{
    if (error.code == 101) {
        NSLog(@"webView error 101: %@", error.localizedDescription);
        return;
    }
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error in Page/Link" message:
                          (NSString*) error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}


- (void) checkButtonStatus {
    
    returnButton.enabled  = self.webView.canGoBack;
    forwardButton.enabled = self.webView.canGoForward;
    
}


- (void) createAndAddButtons {
    
// Using < & > in the buttons instead of licensed images.
// I recommend using http://www.glyphish.com icons if you want something
//   legal, inexpensive, and nice looking.
    
    
//  The following lines is if you have a licensed or owned image for Right arrow
//    UIImage *buttonImage = [UIImage imageNamed:@"Left"];
//    returnButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonPressed)];
    
    returnButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonPressed)];
  
    returnButton.enabled = NO;

//  The following lines is if you have a licensed or owned image for Right arrow
//    buttonImage = [UIImage imageNamed:@"Right"];
//    forwardButton =[[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonPressed)];
    
    forwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonPressed)];
    forwardButton.enabled = NO;
        
    NSArray *buttons = [NSArray arrayWithObjects:forwardButton, returnButton, nil];
    [self.navigationItem setRightBarButtonItems:buttons animated:YES];
}


- (void) returnButtonPressed {
    if ( webView.canGoBack) {
        [webView goBack];
        [self startTimer];
    }
}

- (void) forwardButtonPressed {
    if (webView.canGoForward) {
        [webView goForward];
        [self startTimer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
