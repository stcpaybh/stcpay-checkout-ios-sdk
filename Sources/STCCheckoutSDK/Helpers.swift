//
//  File.swift
//  
//
//  Created by Muhammad Zahid Imran on 19/09/2023.
//

import Foundation
import CryptoKit

class Helpers {
    public static func getHashedData(secretKey : String, data : String) -> String {
        let key = SymmetricKey(data: Data(secretKey.utf8))
        let signature = HMAC<SHA512>.authenticationCode(for: Data(data.utf8), using: key)
        return Data(signature).base64EncodedString()
    }
}

extension URL {
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension String {
    func urlEncoded() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    }
}

extension Notification.Name {

    public static let STCPaymentResponse = Notification.Name("STCPaymentResponse")

}

extension Double {
    // Calucate percentage based on given values
    func calculatePercentage(percentageVal: Double) -> Double {
        let val = self * percentageVal
        return val / 100.0
    }
    
    func upto2Decimal() -> String {
        if let formattedNum = self.getNumberFormater(2) {
            return formattedNum
        }
        return String(format: "%.2f", self)
    }
    
    func upto3Decimal() -> String {
        if let formattedNum = self.getNumberFormater(3) {
            return formattedNum
        }
        return String(format: "%.3f", self)
    }
    
    func upto1Decimal() -> String {
        if let formattedNum = self.getNumberFormater(1) {
            return formattedNum
        }
        return String(format: "%.1f", self)
    }
    
    func getNumberFormater(_ digits: Int) -> String? {
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
