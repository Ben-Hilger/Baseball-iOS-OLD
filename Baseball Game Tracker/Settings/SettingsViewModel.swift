// Copyright 2021-Present Benjamin Hilger

import Foundation
import SwiftUI

class SettingsViewModel : ObservableObject {
    
    @Published var runnerDisplaySettings : RunnerDislaySetting = .LastName
    @Published var fielderDisplaySettings : RunnerDislaySetting = .Initials
    @Published var runnerFontSize : Double = 25.0
    @Published var fielderFontSize : Double = 25.0
    @Published var fieldSelectionType : FieldSettingsSelectionType = .None
    
    @Published var numberOfInnings : Double = 9.0
    @Published var scoreCardViewSettingsType : ScoreCardSettingType = .None
    
    @Published var formulas : [Formula] = []
    @Published var pitcherFilterTypes : PitcherFilterType = .All
    @Published var hitterFilterTypes : HitterFilterType = .All
    @Published var pitchFilterType : PitchType = .None
    @Published var playerOnBaseFilter : PlayerOnBaseFilter = .Overall
    @Published var pitchVelocityFilter : Double = 90.0
    @Published var pitchVelocityFilterType : PitchVelocityFilter = .Disabled
    @Published var pitcherSelectedFilterType : PlayerFilter = .All
    @Published var pitcherSelected : String? = nil
    @Published var hitterSelectedFilterType : PlayerFilter = .All
    @Published var hitterSelected : String? = nil
    @Published var allFormulas : [Formula] = [QABPercentageFormula(), FPSPercentageFormula(), WhiffRateFormula(), FirstPitchFastballPercentage(), SluggingPercentage(), BattingAverage(), IsolatedPower(), BattingAverageBallsInPlay(), GroundBallPercentage(), OnBasePercentage(), OnBaseSluggingPercentage()]
    
    @Published var inningToViewHistory : Int = 1
    
    @Published var handMode: HandUsed = .Right
    
    static var isInTestMode: Bool = false
}
