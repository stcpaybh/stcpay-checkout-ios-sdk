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
    
    STCCheckoutSDK *pay = [[STCCheckoutSDK.Builder new]
//                           setSecretKeyWithSecretKey:@"9ec20e2b5bc569f37ad3df432b70dbb0eca39db68cd3be63d103f8ce9d1217bcef95d688334de74553f9df0c4e0171cc65f65e94c4beb8a3420cfed31ef2ab50"]
//                           setMerchantIdWithMerchantId:@"1"]
//                           setAmountWithAmount:500]
//                           setExternalIDWithExternalRefId:[NSString stringWithFormat:@"%d", arc4random_uniform(5900) + 100]]
//                           build];
//    [pay proceed];
//    @catch (STCCheckoutSDKError *error) {
//        if ([error isKindOfClass:[STCCheckoutSDKError class]]) {
//            switch (error) {
//                case STCCheckoutSDKError.stcAppNotInstalled:
//                    NSLog(@"App Not Installed");
//                    break;
//                case STCCheckoutSDKError.invalidSecretKey:
//                    NSLog(@"Invalid secret key");
//                    break;
//                case STCCheckoutSDKError.invalidMerchantID:
//                    NSLog(@"Invalid merchant id");
//                    break;
//                case STCCheckoutSDKError.invalidAmount:
//                    NSLog(@"Invalid Amount");
//                    break;
//                case STCCheckoutSDKError.invalidExternalID:
//                    NSLog(@"Invalid External ID");
//                    break;
//                default:
//                    break;
//            }
//        }
//    }
//    @catch (NSException *exception) {
//        // Handle other exceptions if needed
//    }
}
@end
