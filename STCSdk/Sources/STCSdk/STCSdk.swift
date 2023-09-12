import UIKit
import CryptoKit

public enum STCSdkError: Error {
    case stcAppNotInstalled
}

public final class STCSdk {

    private var secretKey: String
    private var merchantId: String
    private var orderId: String
    private var amount: Double

    private init(secretKey: String, merchantId: String, orderId: String, amount: Double) {
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

        public func build() -> STCSdk {
            return STCSdk(secretKey: secretKey, merchantId: merchantId, orderId: orderId, amount: amount)
        }
    }

    public func proceed() throws {
        let request = "\(merchantId).\(secretKey)"
        let token = SHA256.hash(data: Data(request.utf8))
        let tokenString = token.compactMap { String(format: "%02x", $0) }.joined()
        
        let stcURL = "stcpaydevfrombenefitpay://checkout.stc?merchant_id=\(merchantId)&order_id=\(orderId)&amount:\(amount)&token=\(tokenString)"
        let url = URL(string: stcURL)!
        if UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url)
        } else {
            throw STCSdkError.stcAppNotInstalled
        }
    }
}

extension Double {
    // Calucate percentage based on given values
    public func calculatePercentage(percentageVal: Double) -> Double {
        let val = self * percentageVal
        return val / 100.0
    }
    
    public func upto2Decimal() -> String {
        if let formattedNum = self.getNumberFormater(2) {
            return formattedNum
        }
        return String(format: "%.2f", self)
    }
    
    public func upto3Decimal() -> String {
        if let formattedNum = self.getNumberFormater(3) {
            return formattedNum
        }
        return String(format: "%.3f", self)
    }
    
    public func upto1Decimal() -> String {
        if let formattedNum = self.getNumberFormater(1) {
            return formattedNum
        }
        return String(format: "%.1f", self)
    }
    
    public func getNumberFormater(_ digits: Int) -> String? {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.usesSignificantDigits = false
        numberFormat.usesGroupingSeparator = false
        numberFormat.locale = Locale(identifier: "en_US")
        // Rounding down drops the extra digits without rounding.
        numberFormat.roundingMode = .halfUp
        numberFormat.minimumFractionDigits = digits
        numberFormat.maximumFractionDigits = digits
        let number = NSNumber(value: self)

        return numberFormat.string(from: number)
    }
}
