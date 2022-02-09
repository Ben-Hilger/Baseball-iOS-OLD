// Copyright 2021-Present Benjamin Hilger

import Foundation

class PositionUtil {
    
    static func getPositionsPrintable(forPostions positions : [Positions]) -> String {
        var stringPos = ""
        for pos in positions {
            stringPos += "\(pos)\n"
        }
        if let index = stringPos.lastIndex(of: ",") {
            return String(stringPos[...index])
        }
        return stringPos
    }
    
}
