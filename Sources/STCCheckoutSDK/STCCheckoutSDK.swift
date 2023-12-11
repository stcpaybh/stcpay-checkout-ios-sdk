import UIKit
import CryptoKit

public enum STCCheckoutSDKError: Error {
    case stcAppNotInstalled
    case invalidSecretKey
    case invalidMerchantID
    case invalidAmount
    ///case invalidMerchangeName
    case invalidExternalID
}

private let debugURLScheme = "stcPayBhDebug"
private let URLScheme = "stcPayBh"
private let appUrl = "itms-apps://apple.com/app/id1336421084"

@objc public final class STCCheckoutSDK: NSObject {

    private var secretKey: String
    private var merchantId: String
    private var amount: Double
    private var externalRefId: String

    private init(secretKey: String, merchantId: String, amount: Double, externalRefId: String) throws {
        guard !secretKey.isEmpty else {
            throw STCCheckoutSDKError.invalidSecretKey
        }
        guard !merchantId.isEmpty else {
            throw STCCheckoutSDKError.invalidMerchantID
        }
        guard amount > 0.0 else {
            throw STCCheckoutSDKError.invalidAmount
        }
        guard !externalRefId.isEmpty else {
            throw STCCheckoutSDKError.invalidExternalID
        }
        
        self.secretKey = secretKey
        self.merchantId = merchantId
        self.amount = amount
        self.externalRefId = externalRefId
    }

    @objc public final class Builder: NSObject {
        private var secretKey: String = ""
        private var merchantId: String = ""
        private var amount: Double = 0.0
        private var merchantName: String = ""
        private var externalRefId: String = ""
 
        @objc public override init() { }

        @objc public func setSecretKey(secretKey: String) -> Builder {
            self.secretKey = secretKey
            return self
        }

        @objc public func setMerchantId(merchantId: String) -> Builder {
            self.merchantId = merchantId
            return self
        }

        @objc public func setAmount(amount: Double) -> Builder {
            self.amount = amount
            return self
        }

        @objc public func setExternalID(externalRefId: String) -> Builder {
            self.externalRefId = externalRefId
            return self
        }

        @objc public func build() throws -> STCCheckoutSDK {
            do {
                return try STCCheckoutSDK(secretKey: secretKey, merchantId: merchantId, amount: amount, externalRefId: externalRefId)
            }
        }
    }

    @objc public func proceed() throws {
        let request = "\(merchantId)-\(externalRefId)-\(amount.upto3Decimal())"
        let signatureString = Helpers.getHashedData(secretKey: secretKey, data: request)
        let params = "merchant_id=\(merchantId)&amount=\(amount)&token=\(signatureString)&external_ref_id=\(externalRefId)"
        let stcDebugURL = "\(debugURLScheme)://checkout.stc?\(params.urlEncoded() ?? "")"
        let stcURL = "\(URLScheme)://checkout.stc?\(params.urlEncoded() ?? "")"
        
        if let url = URL(string: stcDebugURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: stcURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            if let url = URL(string:appUrl) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc public static func consumeResponseFromSTCGateway(url: URL) -> Bool {
        if url.absoluteString.contains("://checkout.stc") {
            let params = url.queryParameters
            print("Responsefromconsumerapp \(params)")
            NotificationCenter.default.post(name: .STCPaymentResponse, object: params)
            return true
        } else {
            return false
        }
    }
}
