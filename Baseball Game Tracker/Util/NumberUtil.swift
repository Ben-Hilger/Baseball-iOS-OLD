// Copyright 2021-Present Benjamin Hilger

import Foundation

class NumberUtil {
    
    static func getNumberEnding(forNumber num : Int) -> String {
        if num%10 == 1 && num != 11 {
            return "st"
        } else if num%10 == 2 && num != 12 {
            return "nd"
        } else if num%10 == 3 && num != 13 {
            return "rd"
        }
        return "th"
    }
}
