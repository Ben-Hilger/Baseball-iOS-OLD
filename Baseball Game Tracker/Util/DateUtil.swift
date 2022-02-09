// Copyright 2021-Present Benjamin Hilger

import Foundation

class DateUtil {
    
    static func getFormattedDay(forDate d : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: d)
    }
    
}
