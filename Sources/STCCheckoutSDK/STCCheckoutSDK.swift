import UIKit
import CryptoKit

public enum STCCheckoutSDKError: Error {
    case stcAppNotInstalled
    case invalidSecretKey
    case invalidMerchantID
    case invalidOrderId
    case invalidAmount
    ///case invalidMerchangeName
    case invalidCallbackTag
    case invalidExternalID
}

private let debugURLScheme = "stcPayBhDebug"
private let URLScheme = "stcPayBh"
private let appUrl = "itms-apps://apple.com/app/id1336421084"

public final class STCCheckoutSDK {

    private var secretKey: String
    private var merchantId: String
    private var orderId: String
    private var amount: Double
    private var callBackTag: String
    private var external_ref_id: String

    private init(secretKey: String, merchantId: String, orderId: String, amount: Double, callBackTag: String, external_ref_id: String) throws {
        guard !secretKey.isEmpty else {
            throw STCCheckoutSDKError.invalidSecretKey
        }
        guard !merchantId.isEmpty else {
            throw STCCheckoutSDKError.invalidMerchantID
        }
        guard !orderId.isEmpty else {
            throw STCCheckoutSDKError.invalidOrderId
        }
        guard amount > 0.0 else {
            throw STCCheckoutSDKError.invalidAmount
        }
        guard !callBackTag.isEmpty else {
            throw STCCheckoutSDKError.invalidCallbackTag
        }
        guard !external_ref_id.isEmpty else {
            throw STCCheckoutSDKError.invalidExternalID
        }
        
        self.secretKey = secretKey
        self.merchantId = merchantId
        self.orderId = orderId
        self.amount = amount
        self.callBackTag = callBackTag
        self.external_ref_id = external_ref_id
    }

    public final class Builder {
        private var secretKey: String = ""
        private var merchantId: String = ""
        private var orderId: String = ""
        private var amount: Double = 0.0
        private var merchantName: String = ""
        private var callBackTag: String = ""
        private var external_ref_id: String = ""
 
        public init() { }

        public func setSecretKey(secretKey: String) -> Builder {
            self.secretKey = secretKey
            return self
        }

        public func setMerchantId(merchantId: String) -> Builder {
            self.merchantId = merchantId
            return self
        }

        public func setOrderId(orderId: String) -> Builder {
            self.orderId = orderId
            return self
        }

        public func setAmount(amount: Double) -> Builder {
            self.amount = amount
            return self
        }
        
        public func setCallBackTag(tag: String) -> Builder {
            self.callBackTag = tag
            return self
        }

        public func setExternalID(external_ref_id: String) -> Builder {
            self.external_ref_id = external_ref_id
            return self
        }

        public func build() throws -> STCCheckoutSDK {
            do {
                return try STCCheckoutSDK(secretKey: secretKey, merchantId: merchantId, orderId: orderId, amount: amount, callBackTag: callBackTag, external_ref_id: external_ref_id)
            }
        }
    }

    public func proceed() throws {
        let request = "\(merchantId)-\(external_ref_id)-\(amount.upto3Decimal())"
        let key = SymmetricKey(data: Data(secretKey.utf8))
        let signature = HMAC<SHA512>.authenticationCode(for: Data(request.utf8), using: key)
        let signatureString = Data(signature).base64EncodedString()
        let params = "merchant_id=\(merchantId)&order_id=\(orderId)&amount=\(amount)&token=\(signatureString)&call_back_tag=\(callBackTag)&external_ref_id=\(external_ref_id)"
        let stcDebugURL = "\(debugURLScheme)://checkout.stc?\(params.urlEncoded() ?? "")"
        let stcURL = "\(URLScheme)://checkout.stc?\(params.urlEncoded() ?? "")"
        
        if let url = URL(string: stcDebugURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: stcURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            if let url = URL(string:appUrl ) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            throw STCCheckoutSDKError.stcAppNotInstalled
        }
    }
    
    public static func consumeResponseFromSTCGateway(url: URL) -> Bool {
        if url.absoluteString.contains("://checkout.stc") {
            let params = url.queryParameters
            NotificationCenter.default.post(name: .STCPaymentResponse, object: params)
            return true
        } else {
            return false
        }
    }
}
