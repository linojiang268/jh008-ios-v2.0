//
//  BarcodeViewController.m
//  ZXingDemo
//
//  Created by CP_Kiwi on 14-5-5.
//  Copyright (c) 2014年 cpsoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BarcodeViewController.h"

@interface BarCodeScanView : UIView {
    UIImageView * lightBar;
}
@property (nonatomic, retain) NSTimer * repeatTimer;

- (void)startAnimations;
- (void)stopAnimations;

@end

@implementation BarCodeScanView
@synthesize repeatTimer;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        lightBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barCode_light"]];
        lightBar.alpha = 0;
        [self addSubview:lightBar];
        
        UIImageView * frameView = [[UIImageView alloc] initWithFrame:self.bounds];
        frameView.image = [UIImage imageNamed:@"barCode_frame"];
        [self addSubview:frameView];
    }
    return self;
}

- (void)startAnimations {
    [self animationRepeatHandler:nil];
}

- (void)stopAnimations {
    lightBar.alpha = 0;
    if ([repeatTimer isValid]) {
        [repeatTimer invalidate];
        self.repeatTimer = nil;
    }
}

- (void)animationRepeatHandler:(NSTimer*)sender {
    lightBar.alpha = 1;
    CGRect frame = lightBar.frame;
    frame.origin.y = -frame.size.height;
    lightBar.frame = frame;
    [UIView animateWithDuration:1.75
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        CGRect frame = lightBar.frame;
        frame.origin.y = self.frame.size.height;
        lightBar.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animationRepeatHandler:) userInfo:nil repeats:NO];
        }
    }];
}


//- (void)drawRect:(CGRect)rect {
//    UIImage * bkg = [UIImage imageNamed:@"barCode_frame"];
//    [bkg drawInRect:rect];
//}

@end

@interface BarcodeViewController () {
    IBOutlet BarCodeScanView * scanView;
    UIButton * btnLEDLightOn;
    UIButton * btnLEDLightOff;
}

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, copy) void(^completeHandler)(NSString *result);

@end

@implementation BarcodeViewController

+ (id)controllerWithCompleteHandler:(void (^)(NSString *))completeHandler {
    BarcodeViewController * con = [[BarcodeViewController alloc] init];
    con.completeHandler = completeHandler;
    return con;
}

- (id)init {
    if (self = [super initWithNibName:@"BarcodeViewController" bundle:nil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //[self setupComponents];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_yellow") highlight:nil clickHandler:^(BlockBarButtonItem *item){
        [wself dismissViewControllerAnimated:YES completion:nil];
    }]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [scanView startAnimations];
    [self setupCamera];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [scanView stopAnimations];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)btnCancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)btnLEDLightPressed:(id)sender {
    if ([self setLEDLightON:YES]) {
        btnLEDLightOn.hidden = YES;
        btnLEDLightOff.hidden = NO;
    }
}
- (void)btnLEDLightOffPressed:(id)sender {
    if ([self setLEDLightON:NO]) {
        btnLEDLightOn.hidden = NO;
        btnLEDLightOff.hidden = YES;
    }
}

#define btnMarginTop 40

- (void)setupComponents {
    UIButton * btn = [self buttonWithImage:@"barCode_btnCancel" title:@"Back"];
    btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [btn addTarget:self action:@selector(btnCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, btnMarginTop, 80, 36);
    //[self.view addSubview:btn];
    
    btn = [self buttonWithImage:@"barCode_btnLight" title:@"barcode_light_on"];
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [btn addTarget:self action:@selector(btnLEDLightPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.view.frame.size.width - 100, btnMarginTop, 80, 36);
    //[self.view addSubview:btn];
    btnLEDLightOn = btn;
    
    btn = [self buttonWithImage:@"barCode_btnLight" title:@"barcode_light_off"];
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [btn addTarget:self action:@selector(btnLEDLightOffPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.view.frame.size.width - 100, btnMarginTop, 80, 36);
    //[self.view addSubview:btn];
    btn.hidden = YES;
    btnLEDLightOff = btn;
}

- (void)setupCamera {
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (self.device == nil) return;
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [self.session startRunning];
}

- (BOOL)setLEDLightON:(BOOL)bl {
    AVCaptureDevice * device = self.device;
    BOOL res = [device hasTorch];
    if (res) {
        [device lockForConfiguration:nil];
        [device setTorchMode:bl ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    return res;
}

- (UIButton*)buttonWithImage:(NSString*)imgName title:(NSString*)title {
    UIImage * btnBkg = [[UIImage imageNamed:@"barCode_btn_roundRect_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 21, 17, 21)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!string_is_empty(imgName)) btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    else btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [btn setBackgroundImage:btnBkg forState:UIControlStateNormal];
    if (!string_is_empty(imgName)) [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    return btn;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [scanView stopAnimations];
    NSString * stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (stringValue) {
            if (self.completeHandler) {
                self.completeHandler(stringValue);
            }
        } else {
            alert(nil, @"扫描失败");
        }
    }];
}

@end


