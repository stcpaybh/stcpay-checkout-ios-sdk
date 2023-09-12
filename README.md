##Payment SDK STC

Payment SDK allows you add STC wallet as payment gateway to ny iOS app.

#Installation

For installation you required to have a `merchant_id` and `secret_key` from STC Bahrain. 

You may add STC SDK to you swift project via SPM (Swift Project Manager) using below URL

> URL will be provided later
> 

# How to use

Making payment with STC SDK is pretty simple requires just a single call to payment SDK which will load STC app from your phone to checkout page.

```
import STCSdk

STC.makePayment(merchantID: "xxxxx", secretKey: "xxxxxx", orderID: "order id goes here", amount: 9.00)

```

This will open STC app after login you will be redirected to checkout page once payment is done either case *success* or *failure* you will be redirected to source app for checkout feedback.

On source application just listen to *Notification name*

```
extension Notification.Name {

    static let STCPaymentResponse = Notification.Name("STCPaymentResponse")

}

```

like below 

```
NotificationCenter.default.publisher(for: . STCPaymentResponse).sink {[weak self] notification in
            if let response = notification.object as? [String: Any] {
                ///response from checkout
            }
        }
        .store(in: &cancellable)
        
```
