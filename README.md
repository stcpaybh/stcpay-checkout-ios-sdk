# stc pay checkout iOS Sdk

## Installation

You may add stc pay checkout SDK to your swift project via SPM (Swift Project Manager) using below URL

> https://github.com/stcpaybh/stcpay-checkout-ios-sdk.git

## Sample Apps

A project with basic example is provided [here](https://github.com/stcpaybh/stcpay-checkout-ios-sdk/tree/main/Demo/STCSdkProject).

## Code Initialization

To initialize the stc pay checkout SDK in your app, use below snippet in your app's Application class or where ever you seems appropiate:

#### Initialize SDK

This will open stc pay app, after login you will be redirected to checkout page once payment is done, either *success* or *failure* you will be redirected to source app for checkout callback.


```
do {
        let pay = try STCCheckoutSDK.Builder()
        .setSecretKey(secretKey: "") /* Secret key obtained from stc pay */
        .setMerchantId(merchantId: "") /* Merchat Id obtained from stc pay */
        .setAmount(amount: ) /* Amount for that payment */
        .setExternalID(externalRefId: "") /* Your own orderId for that payment */
        .build()
        try pay.proceed()
    } catch STCCheckoutSDKError.stcAppNotInstalled {
        print("App Not Installed")
    } catch STCCheckoutSDKError.invalidSecretKey {
        print("Invalid secret key")
    } catch STCCheckoutSDKError.invalidMerchantID {
        print("Invalid merchant id")
    } catch STCCheckoutSDKError.invalidAmount {
        print("Invalid Amount")
    } catch STCCheckoutSDKError.invalidExternalID{
        print("Invalid External ID")
    }
    catch {
        
    }
        
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

### Callback

#### For Swift UI

Listen to onOpenURL like below
```
.onOpenURL { url in
    STCCheckoutSDK.consumeResponseFromSTCGateway(url: url)
}
```
On source application just listen to *Notification name* like below 

```
NotificationCenter.default.publisher(for: NSNotification.Name.STCPaymentResponse)) { notification in
    if let response = notification.object as? [String: Any] {
    ///response from checkout
    }
}
.store(in: &cancellable)
        
```

#### For UI Kit

You will get the callback in AppDelegate, which you can update it:
```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if url.absoluteString.contains("://checkout.stc") {
        STCCheckoutSDK.consumeResponseFromSTCGateway(url: url)
    }
}
```

And then you to register to listen to the notification in your UIController

// Register to receive notification
```
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification(_:)), name: NSNotification.Name.STCPaymentResponse, object: nil)
```
where ```#selector(YourClassName.methodOfReceivedNotification(_:))``` will be your function in which you will receive ```notification``` as parameter and then you can do:

```
if let response = notification.object as? [String: Any] {
    ///response from checkout
}
```


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

##### Endpoint
#### UAT
https://api.uat.stcpay.com.bh/api/mobile/StcpayCheckout/InquireTransactionStatus
#### Pre-Prod
https://api.pre-prod.stcpay.com.bh/api/mobile/StcpayCheckout/InquireTransactionStatus
#### Prod
https://api.stcpay.com.bh/api/mobile/StcpayCheckout/InquireTransactionStatus

##### Request

```
{
  "merchant-id": "<your merchant ID>",
  "stcpay-transaction-id": <transaction ID received from successful transaction from stc pay checkout SDK>,
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
declared in [Helpers.swift](https://github.com/stcpaybh/stcpay-checkout-ios-sdk/blob/main/Sources/STCCheckoutSDK/Helpers.swift).

Following are functions you need to call for SDK initialization:

| Params |  Description | Type | Required | Default value |
|:---|:---|:---|:---|:---|
| secretKey |Pass the secret key provided already | String | Yes | Should be non-null |
| data | String which you want to encrypt | String| Yes | Should be non-null |

### How to create data
You will create a data string as follow, merchant ID and stc pay transaction ID separated by dash(-):
"<merchant-id>-<stcpay-transaction-id>"
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
