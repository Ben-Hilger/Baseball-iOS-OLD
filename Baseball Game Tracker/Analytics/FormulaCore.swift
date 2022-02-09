// Copyright 2021-Present Benjamin Hilger

import Foundation

class Formula : Equatable {
    
    var numberOfDecimalPlaces : Int = 2
    @Published var analyzeTeam : GameTeamType = .Home
    
    init() {
        
    }
    
    init(teamToAnalyze team : GameTeamType) {
        analyzeTeam = team
    }
    
    func getFormulaShortName() -> String {
        return "Please override this function"
    }
    
    func getFormulaLongName() -> String {
        return "Please override this function"
    }
    
    func getFormulaString() -> String {
        return "Please override this function"
    }
    
    func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        return "Please override this function"
    }
    
    func getNumberDisplayType() -> NumberType {
        return .Number
    }
    
    func format(valueToFormat: Double) -> String {
        switch getNumberDisplayType() {
        case .Number:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = numberOfDecimalPlaces
            return "\(formatter.string(from: NSNumber(value: valueToFormat)) ?? "")"
        case .Percentage:
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            return formatter.string(from: NSNumber(value: valueToFormat)) ?? ""
        }
    }
    
    static func == (lhs: Formula, rhs: Formula) -> Bool {
        return lhs.getFormulaShortName() == rhs.getFormulaShortName()
    }
    
    
    
}

enum NumberType {
    case Percentage
    case Number
}

class QABPercentageFormula : Formula {
 
    override func getFormulaString() -> String {
        return "# of QAB / Total PA"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        let numberQABs = AnalyticsCore.getNumberofQABs(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getNumberofQABs(forTeam: self.analyzeTeam, settingsViewModel: settings)
        let numberPA = AnalyticsCore.getTotalPA(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalPA(forTeam: self.analyzeTeam, settingsViewModel: settings)
        return format(valueToFormat: numberPA == 0 ? 0 : Double(numberQABs)/Double(numberPA))
    }

    override func getFormulaShortName() -> String {
        return "QAB%"
    }
    
    override func getFormulaLongName() -> String {
        return "Quality-At Bat Percentage"
    }
     
    override func getNumberDisplayType() -> NumberType {
        return .Percentage
    }
    
}

class FPSPercentageFormula : Formula {
    
    override func getFormulaShortName() -> String {
        return "FPS%"
    }
    
    override func getFormulaLongName() -> String {
        return "First Pitch Strike Percentage"
    }
    
    override func getFormulaString() -> String {
        return "# of 0-0 strikes/# of PA"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        let numberFPS = AnalyticsCore.getTotalFPS(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalFPS(forTeam: self.analyzeTeam, settingsViewModel: settings)
        let numberPA = AnalyticsCore.getTotalPA(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalPA(forTeam: self.analyzeTeam, settingsViewModel: settings)
        return format(valueToFormat: numberPA == 0 ? 0 : Double(numberFPS)/Double(numberPA))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Percentage
    }

}

class WhiffRateFormula : Formula {
    
    override func getFormulaShortName() -> String {
        return "Wiff%"
    }
    
    override func getFormulaLongName() -> String {
        return "Whiff Rate"
    }
    
    override func getFormulaString() -> String {
        return "# of swing and misses/# of swings"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        let numberSwingMiss = AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withPitchOutcomes: [.StrikeSwingMiss, .PassedBallStrikeSwinging, .WildPitchStrikeSwinging], forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotal(withPitchOutcomes: [.StrikeSwingMiss, .PassedBallStrikeSwinging, .WildPitchStrikeSwinging], forTeam: self.analyzeTeam, settingsViewModel: settings)//gameViewModel.getTotalSwingsAndMisses(forTeam: team, settingsViewModel: settings)
        let numberSwing = AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withPitchOutcomes: [.StrikeSwingMiss, .StrikeCalled, .BIP, .PassedBallStrikeSwinging, .WildPitchStrikeSwinging, .FoulBall], forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotal(withPitchOutcomes: [.StrikeSwingMiss, .StrikeCalled, .BIP, .PassedBallStrikeSwinging, .WildPitchStrikeSwinging, .FoulBall], forTeam: self.analyzeTeam, settingsViewModel: settings)//gameViewModel.getTotalSwings(forTeam: team, settingsViewModel: settings)
        return format(valueToFormat: numberSwing == 0 ? 0 : Double(numberSwingMiss)/Double(numberSwing))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Percentage
    }
}

class FirstPitchFastballPercentage : Formula {
    
    override func getFormulaShortName() -> String {
        return "FPFS%"
    }
    
    override func getFormulaLongName() -> String {
        return "First Pitch Fastball Percentage"
    }
    
    override func getFormulaString() -> String {
        return "# of 0-0 fastballs/# of PA"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        let numberFirstPitchFB = AnalyticsCore.getTotalFirstPitchFastball(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalFirstPitchFastball(forTeam: self.analyzeTeam, settingsViewModel: settings)
        let numberPA = AnalyticsCore.getTotalPA(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings)//gameViewModel.getTotalPA(forTeam: self.analyzeTeam, settingsViewModel: settings)
        return format(valueToFormat: numberPA == 0 ? 0 : Double(numberFirstPitchFB)/Double(numberPA))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Percentage
    }
}

class SluggingPercentage : Formula {
    
    override init() {
        super.init()
        // Changes the number of decimal places to 3
        numberOfDecimalPlaces = 3
    }
    
    override init(teamToAnalyze team: GameTeamType) {
        super.init(teamToAnalyze: team)
        self.numberOfDecimalPlaces = 3
    }
    
    override func getFormulaShortName() -> String {
        return "SLG"
    }
    
    override func getFormulaLongName() -> String {
        return "Slugging Percentage"
    }
    
    override func getFormulaString() -> String {
        return "# of total bases/# of ABs"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        var numberAtBats = AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalAB(forTeam: self.analyzeTeam, settingsViewModel: settings)
        var numberBases = AnalyticsCore.getTotalBases(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalBases(forTeam: self.analyzeTeam, settingsViewModel: settings)
        if includeSummaryData {
            for data in gameViewModel.summaryData {
                if let hitter = hitter, data.member.memberID == hitter {
                    for game in data.gamesPlayed {
                        numberAtBats += game.numAtBats
                        for zone in game.zones {
                            numberBases += zone.num1B + zone.num2B*2 + zone.num3B*3 + zone.numHR*4
                        }
                    }
                } else if hitter == nil {
                    for game in data.gamesPlayed {
                        numberAtBats += game.numAtBats
                        for zone in game.zones {
                            numberBases += zone.num1B + zone.num2B*2 + zone.num3B*3 + zone.numHR*4
                        }
                    }
                }
            }
        }
        return format(valueToFormat: numberAtBats == 0 ? 0 : Double(numberBases)/Double(numberAtBats))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Number
    }
}

class BattingAverage : Formula {

    override func getFormulaShortName() -> String {
        return "AVG"
    }
    
    override func getFormulaLongName() -> String {
        return "Batting Average"
    }
    
    override func getFormulaString() -> String {
        return "# of total bases/# of ABs"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        var additionalAtBats = 0
        var additionalHits = 0
        if includeSummaryData {
            for data in gameViewModel.summaryData {
                if let hitter = hitter {
                    if data.member.memberID == hitter {
                        for game in data.gamesPlayed {
                            additionalAtBats = game.numAtBats
                            for zone in game.zones {
                                additionalHits += zone.numHit
                            }
                        }
                    }
                } else {
                    for game in data.gamesPlayed {
                        additionalAtBats = game.numAtBats
                        for zone in game.zones {
                            additionalHits += zone.numHit
                        }
                    }
                }
            }
        }
        let numberAtBats = AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalAB(forTeam: self.analyzeTeam, settingsViewModel: settings)
        let numberHits = AnalyticsCore.getTotalHits(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalHits(forTeam: self.analyzeTeam, settingsViewModel: settings)
        return format(valueToFormat: numberAtBats+additionalAtBats == 0 ? 0 : Double(numberHits+additionalHits)/Double(numberAtBats+additionalAtBats))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Number
    }
}

class IsolatedPower : Formula {
    
    override init() {
        super.init()
        // Changes the number of decimal places to 3
        numberOfDecimalPlaces = 3
    }
    
    override init(teamToAnalyze team: GameTeamType) {
        super.init(teamToAnalyze: team)
        self.numberOfDecimalPlaces = 3
    }
    
    override func getFormulaShortName() -> String {
        return "ISO"
    }
    
    override func getFormulaLongName() -> String {
        return "Isolated Power"
    }
    
    override func getFormulaString() -> String {
        return "SLG - AVG"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        let numberAtBats = AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalAB(forTeam: self.analyzeTeam, settingsViewModel: settings)
        let numberBases = AnalyticsCore.getTotalBases(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalBases(forTeam: self.analyzeTeam, settingsViewModel: settings)
        let sluggingPercentage = numberAtBats == 0 ? 0.0 : Double(numberBases)/Double(numberAtBats)
        let numberHits = AnalyticsCore.getTotalHits(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalHits(forTeam: self.analyzeTeam, settingsViewModel: settings)
        let battingAverage = numberAtBats == 0 ? 0.0 : Double(numberHits)/Double(numberAtBats)
        return format(valueToFormat: sluggingPercentage - battingAverage)
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Number
    }
}

class BattingAverageBallsInPlay : Formula {
    
    override init() {
        super.init()
        // Changes the number of decimal places to 3
        numberOfDecimalPlaces = 3
    }
    
    override init(teamToAnalyze team: GameTeamType) {
        super.init(teamToAnalyze: team)
        self.numberOfDecimalPlaces = 3
    }
    
    override func getFormulaShortName() -> String {
        return "BABIP"
    }
    
    override func getFormulaLongName() -> String {
        return "Batting Average on Balls in Play"
    }
    
    override func getFormulaString() -> String {
        return "# of Hits/# of ABs that result in a BIP"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        let numberAtBats = AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalAB(forTeam: self.analyzeTeam, settingsViewModel: settings, withBIPResultFilter: .BIP)
        let numberHits = AnalyticsCore.getTotalHits(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalHits(forTeam: self.analyzeTeam, settingsViewModel: settings)
        return format(valueToFormat: numberHits == 0 ? 0 : Double(numberAtBats)/Double(numberHits))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Number
    }
}

class GroundBallPercentage : Formula {
    
    override func getFormulaShortName() -> String {
        return "GB%"
    }
    
    override func getFormulaLongName() -> String {
        return "Ground Ball Percentage"
    }
    
    override func getFormulaString() -> String {
        return "% of BIPs that are ground balls"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        // Gets all of the AB's that result in a BIP
        let numberBIP = AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalAB(forTeam: self.analyzeTeam, settingsViewModel: settings, withBIPResultFilter: .BIP)
        // Gets all of the BIPs that were gound balls
        let numberGroundBall = AnalyticsCore.getTotalBIPType(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, forBIPType: .GB, withSpecificHitter: hitter, withSpecificPitcher: pitcher)//gameViewModel.getTotalBIPType(forTeam: self.analyzeTeam, settingsViewModel: settings, forBIPType: .GB)
        return format(valueToFormat: numberBIP == 0 ? 0 : Double(numberGroundBall)/Double(numberBIP))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Percentage
    }
}

class OnBasePercentage : Formula {
    
    override init() {
        super.init()
        self.numberOfDecimalPlaces = 3
    }
    
    override init(teamToAnalyze team: GameTeamType) {
        super.init(teamToAnalyze: team)
        self.numberOfDecimalPlaces = 3
    }
    
    override func getFormulaShortName() -> String {
        return "OBP"
    }
    
    override func getFormulaLongName() -> String {
        return "On Base Percentage"
    }
    
    override func getFormulaString() -> String {
        return "(Hits + Walks + Hit by Pitch)/(At Bats + Walks + Hit By Pitch + Sac Flys)"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        var numberWalks = Double(AnalyticsCore.getTotalWalks(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))//gameViewModel.getTotalWalks(forTeam: self.analyzeTeam, settingsViewModel: settings))
        var numberHits = Double(AnalyticsCore.getTotalHits(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))//gameViewModel.getTotalHits(forTeam: self.analyzeTeam, settingsViewModel: settings))
        var numberHBP = Double(AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withPitchOutcomes: [.HBP], forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))//gameViewModel.getTotal(withPitchOutcomes: [.HBP], forTeam: self.analyzeTeam, settingsViewModel: settings))
        var numberAtBats = Double(AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))//gameViewModel.getTotalAB(forTeam: self.analyzeTeam, settingsViewModel: settings))
        var numberSac = Double(AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withBIPOutcomes: [.SacFly], forTeam: analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))//gameViewModel.getTotal(withBIPOutcomes: [.SacFly], forTeam: self.analyzeTeam, settingsViewModel: settings))
        if includeSummaryData {
            for data in gameViewModel.summaryData {
                if let hitter = hitter, data.member.memberID == hitter {
                    for game in data.gamesPlayed {
                        numberWalks += Double(game.numWalks)
                        numberHBP += Double(game.numHBP)
                        numberAtBats += Double(game.numAtBats)
                        numberSac += Double(game.numSacFly)
                        for zone in game.zones {
                            numberHits += Double(zone.numHit)
                        }
                    }
                } else if hitter == nil {
                    for game in data.gamesPlayed {
                        numberWalks += Double(game.numWalks)
                        numberHBP += Double(game.numHBP)
                        numberAtBats += Double(game.numAtBats)
                        numberSac += Double(game.numSacFly)
                        for zone in game.zones {
                            numberHits += Double(zone.numHit)
                        }
                    }
                }
            }
        }
        return format(valueToFormat: (numberAtBats + numberWalks + numberHBP + numberSac) == 0 ? 0 : (numberHits + numberWalks + numberHBP) / (numberAtBats + numberWalks + numberHBP + numberSac))
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Number
    }
}

class OnBaseSluggingPercentage : Formula {
    
    override init() {
        super.init()
        self.numberOfDecimalPlaces = 3
    }
    
    override init(teamToAnalyze team: GameTeamType) {
        super.init(teamToAnalyze: team)
        self.numberOfDecimalPlaces = 3
    }
    
    override func getFormulaShortName() -> String {
        return "OBP + SLG"
    }
    
    override func getFormulaLongName() -> String {
        return "On Base Plus Slugging Percentage"
    }
    
    override func getFormulaString() -> String {
        return "(Hits + Walks + Hit by Pitch)/(At Bats + Walks + Hit By Pitch + Sac Flys) + # of total bases/# of ABs"
    }
    
    override func getFormulaResult(withGameViewModel gameViewModel : GameViewModel, withSettingsViewModel settings : SettingsViewModel, forSpecificHitter hitter : String? = nil, forSpecificPitcher pitcher : String? = nil, includeSummaryData : Bool = false) -> String {
        let numberWalks = Double(AnalyticsCore.getTotalWalks(fromGameViewModel: gameViewModel, forTeam: self.analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))
        let numberHits = Double(AnalyticsCore.getTotalHits(fromGameViewModel: gameViewModel, forTeam: self.analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))
        let numberHBP = Double(AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withPitchOutcomes: [.HBP], forTeam: self.analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))
        let numberAtBats = Double(AnalyticsCore.getTotalAB(fromGameViewModel: gameViewModel, forTeam: self.analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))
        let numberSac = Double(AnalyticsCore.getTotal(fromGameViewModel: gameViewModel, withBIPOutcomes: [.SacFly], forTeam: self.analyzeTeam, settingsViewModel: settings, withSpecificHitter: hitter, withSpecificPitcher: pitcher))
        let OBP = (numberAtBats + numberWalks + numberHBP + numberSac) == 0 ? 0 : (numberHits + numberWalks + numberHBP) / (numberAtBats + numberWalks + numberHBP + numberSac)
        let numberBases = AnalyticsCore.getTotalBases(fromGameViewModel: gameViewModel, forTeam: self.analyzeTeam, settingsViewModel: settings)
        let SLG = numberAtBats == 0 ? 0 : Double(numberBases)/Double(numberAtBats)
        return format(valueToFormat: OBP + SLG)
    }
    
    override func getNumberDisplayType() -> NumberType {
        return .Number
    }
}

enum PitcherFilterType : CaseIterable {
    case LHP
    case RHP
    case All
    
    func getString() -> String {
        switch self {
        case.LHP:
            return "LHP"
        case .RHP:
            return "RHP"
        case .All:
            return "All"
        }
    }
}

enum HitterFilterType : CaseIterable {
    case LHH
    case RHH
    case All
    
    func getString() -> String {
        switch self {
        case.LHH:
            return "LHH"
        case .RHH:
            return "RHH"
        case .All:
            return "All"
        }
    }
}

enum PlayerOnBaseFilter : CaseIterable {
    case RunnersInScoring
    case BasesEmpty
    case Overall
    
    func getString() -> String {
        switch self {
        case .BasesEmpty:
            return "Bases Empty"
        case .Overall:
            return "Overall"
        case .RunnersInScoring:
            return "RISP"
        }
    }
}

enum PitchVelocityFilter : CaseIterable {
    case Enabled
    case Disabled
}

enum PlayerFilter {
    case All
    case Specific
}
