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
                        .setSecretKey(secretKey: "secretKey")
                        .setMerchantId(merchantId: "merchantID")
                        .setOrderId(orderId: "orderid")
                        .setAmount(amount: 2.0)
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
