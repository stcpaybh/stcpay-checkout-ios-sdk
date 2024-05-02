//
//  ViewController.m
//  Demo-Objc
//
//  Created by Muhammad Zahid Imran on 11/12/2023.
//

#import "ViewController.h"
@import STCCheckoutSDK;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)proceedAction:(id)sender {
    NSError *builderError = nil;
    STCCheckoutSDK *pay = [[[[[[[[Builder new]
                           setSecretKeyWithSecretKey:@"9ec20e2b5bc569f37ad3df432b70dbb0eca39db68cd3be63d103f8ce9d1217bcef95d688334de74553f9df0c4e0171cc65f65e94c4beb8a3420cfed31ef2ab50"]
                           setMerchantIdWithMerchantId:@"1"]
                           setAmountWithAmount:500]
                           setExternalIDWithExternalRefId:[NSString stringWithFormat:@"%d", arc4random_uniform(5900) + 100]]
                           setDateWithDate:1714653727]
                           setCallBackWithTag: @"STCSdkProject"] // URL scheme of your project
                           buildAndReturnError: &builderError];
    if (builderError != nil) {
        [self handleError:builderError];
        return;
    }
    NSError *proceedError = nil;
    [pay proceedAndReturnError: &proceedError];
    if (proceedError != nil) {
        [self handleError:proceedError];
    }
}


- (void)handleError:(NSError *)error {
    switch (error.code) {
        case 0: //App not installed
            printf("STC application is not installed");
            break;
        case 1: //Invalid secret key
            printf("Invalid secret key");
            break;
        case 2: //Invalid merchant ID
            printf("Invalid merchant ID");
            break;
        case 3: //Invalid amount
            printf("Invalid amount");
            break;
        case 4: //Invalid externalID
            printf("Invalid externalID");
            break;
        case 5: //Invalid callback tag
            printf("Invalid date");
            break;
        case 6: //Invalid callback tag
            printf("Invalid callback tag");
            break;
            
        default:
            break;
    }
}

@end
