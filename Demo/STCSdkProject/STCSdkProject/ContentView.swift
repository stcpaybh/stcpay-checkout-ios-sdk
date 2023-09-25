//
//  ContentView.swift
//  STCSdkProject
//
//  Created by Muhammad Zahid Imran on 12/09/2023.
//

import SwiftUI
import STCCheckoutSDK

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button {
                
                do {
                    let pay = try STCCheckoutSDK.Builder()
                        .setSecretKey(secretKey: "9ec20e2b5bc569f37ad3df432b70dbb0eca39db68cd3be63d103f8ce9d1217bcef95d688334de74553f9df0c4e0171cc65f65e94c4beb8a3420cfed31ef2ab50")
                        .setMerchantId(merchantId: "1")
                        .setOrderId(orderId: "1")
                        .setAmount(amount: 1.0)
                        .setMerchantName(merchantName: "Demo Merchant")
                        .setCallBackTag(tag: "STCSdkProject")
                        .build()
                    try pay.proceed()
                } catch STCCheckoutSDKError.stcAppNotInstalled {
                    
                } catch STCCheckoutSDKError.invalidSecretKey {
                    print("Invalid secret key")
                } catch STCCheckoutSDKError.invalidMerchantID {
                    print("Invalid merchant id")
                } catch STCCheckoutSDKError.invalidOrderId {
                    
                } catch STCCheckoutSDKError.invalidAmount {
                    
                } catch {
                    
                }
            } label: {
                Text("Hello, world!")
            }

        }
        .padding()
        .onOpenURL { url in
            STCCheckoutSDK.consumeResponseFromSTCGateway(url: url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
