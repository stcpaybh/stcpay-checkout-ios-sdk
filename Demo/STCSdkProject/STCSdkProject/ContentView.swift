//
//  ContentView.swift
//  STCSdkProject
//
//  Created by Muhammad Zahid Imran on 12/09/2023.
//

import SwiftUI
import STCCheckoutSDK

struct ContentView: View {
    
    @State private var didReceivedResponse = false
    @State private var receivedResponse = ""
    
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
                        .setAmount(amount: 500)
                        .setExternalID(externalRefId: String(Int.random(in: 100..<6000)))
                        .setCallBack(tag: "STCSdkProject")
                        .setDate(date: Date().timeIntervalSince1970 * 1000)
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
                } catch STCCheckoutSDKError.invalidCallBackTag{
                    print("Invalid callback tag")
                } catch STCCheckoutSDKError.invalidDate{
                    print("Invalid Date")
                }
                catch {
                    
                }
            } label: {
                Text("Open stc pay app!")
            }

        }
        .padding()
        .onOpenURL { url in
            STCCheckoutSDK.consumeResponseFromSTCGateway(url: url)
        }
        .alert(receivedResponse, isPresented: $didReceivedResponse) {
            Button("OK", role: .cancel) { }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.STCPaymentResponse)) { obj in
            // Change key as per your "userInfo"
            
            if let responseObj = obj.object as? [String:Any], let message = responseObj["message"] as? String {
                receivedResponse = message
                 didReceivedResponse = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
