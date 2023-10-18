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

