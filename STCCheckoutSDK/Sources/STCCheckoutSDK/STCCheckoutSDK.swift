import UIKit
import CryptoKit

public enum STCCheckoutSDKError: Error {
    case stcAppNotInstalled
    case invalidSecretKey
    case invalidMerchantID
    case invalidOrderId
    case invalidAmount
}

private let debugURLScheme = "stcPayBhDebug"
private let URLScheme = "stcPayBh"

public final class STCCheckoutSDK {

    private var secretKey: String
    private var merchantId: String
    private var orderId: String
    private var amount: Double

    private init(secretKey: String, merchantId: String, orderId: String, amount: Double) throws {
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
        self.secretKey = secretKey
        self.merchantId = merchantId
        self.orderId = orderId
        self.amount = amount
    }

    public final class Builder {
        private var secretKey: String = ""
        private var merchantId: String = ""
        private var orderId: String = ""
        private var amount: Double = 0.0

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

        public func build() throws -> STCCheckoutSDK {
            do {
                return try STCCheckoutSDK(secretKey: secretKey, merchantId: merchantId, orderId: orderId, amount: amount)
            }
        }
    }

    public func proceed() throws {
        let request = "\(merchantId)-\(orderId)-\(amount.upto3Decimal())"
        let key = SymmetricKey(data: Data(secretKey.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(request.utf8), using: key)
        let signatureString = Data(signature).map { String(format: "%02hhx", $0) }.joined()
        let stcDebugURL = "\(debugURLScheme)://checkout.stc?merchant_id=\(merchantId)&order_id=\(orderId)&amount:\(amount)&token=\(signatureString)"
        let stcURL = "\(debugURLScheme)://checkout.stc?merchant_id=\(merchantId)&order_id=\(orderId)&amount:\(amount)&token=\(signatureString)"
        if let url = URL(string: stcDebugURL), UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url)
        } else if let url = URL(string: stcURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
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
