//
//  ViewController.m
//  SparkRGB
//
//  Created by Mohit Bhoite on 8/3/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "VBColorPicker.h"

#define ACCESS_TOKEN @"123456"
#define DEVICE_ID @"123456"
#define FUNCTION @"color"
#define SPARKURL @"https://api.spark.io/v1/devices"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (self.cPicker == nil) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.cPicker = [[VBColorPicker alloc] initWithFrame:CGRectMake(0,0, 202, 202)];
        [_cPicker setCenter:self.view.center];
        [self.view addSubview:_cPicker];
        [_cPicker setDelegate:self];
        [_cPicker showPicker];
        
        // set default YES!
        [_cPicker setHideAfterSelection:NO];
    }
}

- (IBAction)sliderBrightness:(id)sender {
    UISlider *brightness = (UISlider *)sender;
    float val = brightness.value;
    NSLog(@"Slider: %f",val);
    
    
    CGFloat redValue,greenValue,blueValue,alphaValue;
    int r,g,b;
    
    [_colorWithBrightness getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
    r = (int) roundf(redValue*255*val);
    g = (int) roundf(greenValue*255*val);
    b = (int) roundf(blueValue*255*val);
    NSLog(@"Picked RGB Values are: %d,%d,%d",r,g,b);
    
    NSString *param = [NSString stringWithFormat:@"R:%dG:%dB:%d,",r,g,b];
    //[self sendRequestWithParameter:param];
    
    [self.connection cancel];
    
    
    NSString *deviceID = [NSString stringWithFormat:DEVICE_ID];
    NSString *accessToken = [NSString stringWithFormat:ACCESS_TOKEN];
    NSString *functionName = [NSString stringWithFormat:FUNCTION];
    NSString *sparkURL = [NSString stringWithFormat:SPARKURL];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    NSString *baseURL = [NSString stringWithFormat:@"%@/%@/%@",sparkURL,deviceID,functionName];
    NSURL *url = [NSURL URLWithString:baseURL];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"access_token=%@&params=%@",accessToken,param];
    //Here you can give your parameters value
    
    //set request content type we MUST set this value.
    
    //[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    
    //start the connection
    [connection start];
}

- (BOOL)shouldAutorotate
{
	//	(iOS 6)
	//	No auto rotating
	return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeBackground:(UIColor *) color {
    [self.view setBackgroundColor:color];
    
}

// set color from picker
- (void) pickedColor:(UIColor *)color {
    
    _colorWithBrightness = color;
    
    CGFloat redValue,greenValue,blueValue,alphaValue;
    int r,g,b;
    
    float val = _brightness.value;
    
    [color getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
    r = (int) roundf(redValue*255*val);
    g = (int) roundf(greenValue*255*val);
    b = (int) roundf(blueValue*255*val);
    NSLog(@"Picked RGB Values are: %d,%d,%d",r,g,b);
    
    //[_rect setBackgroundColor:color];
    [self.view setBackgroundColor:color];
    
    NSString *param = [NSString stringWithFormat:@"R:%dG:%dB:%d,",r,g,b];
    //[self sendRequestWithParameter:param];
    
    [self.connection cancel];
    
    
    NSString *deviceID = [NSString stringWithFormat:DEVICE_ID];
    NSString *accessToken = [NSString stringWithFormat:ACCESS_TOKEN];
    NSString *functionName = [NSString stringWithFormat:FUNCTION];
    NSString *sparkURL = [NSString stringWithFormat:SPARKURL];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    NSString *baseURL = [NSString stringWithFormat:@"%@/%@/%@",sparkURL,deviceID,functionName];
    NSURL *url = [NSURL URLWithString:baseURL];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"access_token=%@&params=%@",accessToken,param];
    //Here you can give your parameters value
    
    //set request content type we MUST set this value.
    
    //[request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    
    //start the connection
    [connection start];

    
    
}


//Add below delegate methods
/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    // NSLog(@"%@" , htmlSTR);
    
    
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: self.receivedData options: NSJSONReadingMutableContainers error: &e];  //I am using sbjson to parse
    
    NSLog(@"data %@",jsonArray);  //here is your output
    
    //show controller with navigation
    
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_cPicker isHidden]) {
        //[_cPicker hidePicker];
    }
}

// show picker by double touch
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
//    if (touch.tapCount == 2) {
//        [_cPicker setCenter:[touch locationInView:self.view]];
//        [_cPicker showPicker];
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self.cPicker removeFromSuperview];
    self.cPicker = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end

