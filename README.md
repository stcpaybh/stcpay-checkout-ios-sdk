# stc pay checkout iOS Sdk

## Installation

You may add stc pay checkout SDK to your swift project via SPM (Swift Project Manager) using below URL:

> https://github.com/stcpaybh/stcpay-checkout-ios-sdk.git
> Version 1.0.1

## Sample Apps

A project with basic example is provided [here](https://github.com/stcpaybh/stcpay-checkout-ios-sdk/tree/feature/objc-support/Demo-Objc).

## Objective-C Implementation

For objective-c implementation installation stays same. 

Import Framework in objc code 

`@import STCCheckoutSDK;`

Build the payment object and proceed

```
NSError *builderError = nil;
    STCCheckoutSDK *pay = [[[[[[Builder new]
                           setSecretKeyWithSecretKey:@"9ec20e2b5bc569f37ad3df432b70dbb0eca39db68cd3be63d103f8ce9d1217bcef95d688334de74553f9df0c4e0171cc65f65e94c4beb8a3420cfed31ef2ab50"]
                           setMerchantIdWithMerchantId:@"1"]
                           setAmountWithAmount:500]
                           setExternalIDWithExternalRefId:[NSString stringWithFormat:@"%d", arc4random_uniform(5900) + 100]]
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
```

###### Attributes

Following are functions you need to call for SDK initialization:

| Function |  Description | Type | Required | Default value |
|:---|:---|:---|:---|:---|
| setSecretKey() |Set the secret key | String | Yes | Should be non-null |
| setMerchantId() | Set the merchant ID | String| Yes | Should be non-null |
| setExternalID() | Set the orderID of your payment | String | Yes| Should be non-null |
| setAmount() | Amount for that orderID | Double| Yes | Should be greater than 0 |


###### Handle errors from SDK

```

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
            
        default:
            break;
    }
}
```  

Also demo Objc project is added in repository you may consult.

### Success

If response has code == 0 then you can get ```transaction_id``` from stc pay which you can use to link it with your own order.

### Failure

In onFailure, code can have following values:

| Result Code values | 
|:---|
|Exception = 1|
|SessionExpired = 2|
|SessionMissing = 24|
|InvalidGuid = 20|
|CustomerProfileNotFound = 26|
|InvalidParam = 35|
|InsufficientBalance = 72|
|IncorrectServiceId = 79|
|TransactionRollback = 84|
|InvalidType = 23|
|OtpLimitExceed = 7|
|IncorrectOtp = 8|
|TryCountExceed = 98|
| Any other code, consider it as unknown exception|

You can use them based on your own criteria for error handling.

```message : String``` which will be a String and you can use it based on your own criteria for error handling.

## Inquire API

Transactions processed from stc pay Checkout SDK can be verified through an API
To inquire the status of a particular transaction you can use below API endpoint:

##### Endpoint (POST)
#### WILL SHARE WHEN REQUIRED

##### Request

```
{
  "merchant-id": "<your merchant ID>",
  "external-transaction-id": <exteranl transaction ID of a merchant>,
  "hash": "<URL encoded hashed string created by you>"
}
```
##### Header
client-secret : <**API secret** provided to you>

#### How to create hash
You will create hash by encrypting a string using the secret key provided already.
You can use the helper function
```
public static func getHashedData(secretKey : String, data : String) -> String
```
declared in [Helpers.swift](https://github.com/stcpaybh/stcpay-checkout-ios-sdk/blob/feature/objc-support/Sources/STCCheckoutSDK/Helpers.swift).

Following are functions you need to call for SDK initialization:

| Params |  Description | Type | Required | Default value |
|:---|:---|:---|:---|:---|
| secretKey |Pass the secret key provided already | String | Yes | Should be non-null |
| data | String which you want to encrypt | String| Yes | Should be non-null |

### How to create data
You will create a data string as follow, merchant ID and external transaction ID separated by dash(-):
"<merchant-id>-<external-transaction-id>"
e.g. Your merchant ID is **1234** & Transaction ID is **5678**, then the data string will be: **"1234-5678"**


##### Response

```
{
    "response-code": 0,
    "response-message": "Paid"
}
```

#### Response Code possible values

| Values | 
|:---|
|0 - Paid|
|1 - Unpaid|
|2 - Merchant not found|
|3 - Transaction not found|
|4 - Hash not matched|
|5 - There is some technical error|
