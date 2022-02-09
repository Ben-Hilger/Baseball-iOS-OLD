// Copyright 2021-Present Benjamin Hilger

import Foundation

class FormatUtil {
    
    static func formatNumber(forNumber number : NSNumber,
                             numberOfDecimalPlaces places: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = places
        return formatter.string(from: number) ?? ""
    }
}
