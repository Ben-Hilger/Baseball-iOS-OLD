// Copyright 2021-Present Benjamin Hilger

import Foundation

class PitchTendenciesViewModel : ObservableObject {
    
    @Published var teamSelected: GameTeamType = .Home
    
    func generatePitchesSummary(withGameViewModel gameViewModel : GameViewModel,
                              forZone zone : PitchLocation? = nil,
                              forPitcher pitcher : MemberInGame? = nil,
                              forHitter hitter : MemberInGame? = nil,
                              playerOnFirst first : Bool? = nil,
                              playerOnSecond second : Bool? = nil,
                              playerOnThird third : Bool? = nil,
                              numBalls: Int? = nil,
                              numStrikes: Int? = nil,
                              pitchingHand: HandUsed? = nil) -> [PitchType : Int] {
        // Store the number of pitches for the zone
        var zoneSmmary : [PitchType : Int] = [:]
        // Create the analytics instance
        let analytics = ZoneAnalytics(withGameSnapshots:
                                        gameViewModel.gameSnapshots[0...gameViewModel.snapShotIndex-1]
                                        .reversed().reversed())
        // Go through all of the pitching options
        for pitchThrown in  PitchType.allCases {
            // Create the filter
            let filterOptions = AnalyticsFilterOptions(pitchThrown: pitchThrown,
                                                    pitcher: pitcher,
                                                    hitter: hitter,
                                                    strikeZone: zone,
                                                    withPlayerOnFirst: first,
                                                    withPlayerOnSecond: second,
                                                    withPlayerOnThird: third,
                                                    numberBalls: numBalls,
                                                    numberStrikes: numStrikes,
                                                    pitcherHand: pitchingHand)
            // Get the number of pitches
            let numberOfPitches =
                analytics.getTotal(withOptions: filterOptions)
            // Store the number of pitches in the summary if the
            // pitch count < 0
            if numberOfPitches > 0 {
                zoneSmmary.updateValue(numberOfPitches, forKey:
                                        pitchThrown)
            }
        }
        // Return the zone summary
        return zoneSmmary
    }
    
    func generatePitchesSummaryByZone(withGameViewModel gameViewModel : GameViewModel,
                              forPitcher pitcher : MemberInGame? = nil,
                              playerOnFirst first : Bool? = nil,
                              playerOnSecond second : Bool? = nil,
                              playerOnThird third : Bool? = nil,
                              numBalls : Int? = nil,
                              numStrikes : Int? = nil,
                              pitcherHand: HandUsed? = nil,
                              withHitter hitter: MemberInGame? = nil,
                              withTeam team: GameTeamType? = nil) -> [PitchLocation : [PitchType : Int]] {
        var zoneLocSummary : [PitchLocation : [PitchType : Int]] = [:]
        for zone in PitchLocation.allCases {
            // Store the number of pitches for the zone
            var zoneSmmary : [PitchType : Int] = [:]
            // Create the analytics instance
            let analytics = ZoneAnalytics(withGameSnapshots:
                                            gameViewModel.gameSnapshots[0...gameViewModel.snapShotIndex-1]
                                            .reversed().reversed())
            // Go through all of the pitching options
            for pitchThrown in  PitchType.allCases {
                // Create the filter
                let filterOptions = AnalyticsFilterOptions(pitchThrown: pitchThrown,
                                                        pitcher: pitcher,
                                                        hitter: hitter,
                                                        strikeZone: zone,
                                                        withPlayerOnFirst: first,
                                                        withPlayerOnSecond: second,
                                                        withPlayerOnThird: third,
                                                        numberBalls: numBalls,
                                                        numberStrikes: numStrikes,
                                                        pitcherHand: pitcherHand,
                                                        team: team)
                // Get the number of pitches
                let numberOfPitches =
                    analytics.getTotal(withOptions: filterOptions)
                // Store the number of pitches in the summary if the
                // pitch count < 0
                if numberOfPitches > 0 {
                    zoneSmmary.updateValue(numberOfPitches, forKey:
                                            pitchThrown)
                }
            }
            
            zoneLocSummary.updateValue(zoneSmmary, forKey: zone)
        }
        
        // Return the zone summary
        return zoneLocSummary
    }
    
    func generatePitchSummary(withGameViewModel gameViewModel : GameViewModel,
                              forZone zone : PitchLocation? = nil,
                              forPitchThrown pitchThrown: PitchType,
                              forPitcher pitcher : MemberInGame? = nil,
                              forHitter hitter: MemberInGame? = nil,
                              playerOnFirst first : Bool? = nil,
                              playerOnSecond second : Bool? = nil,
                              playerOnThird third : Bool? = nil,
                              numBalls : Int? = nil,
                              numStrikes : Int? = nil,
                              pitchingHand: HandUsed? = nil) -> Int {
        // Create the analytics instance
        let analytics = ZoneAnalytics(withGameSnapshots:
                                        gameViewModel.gameSnapshots)
        var numberOfPitches = 0
        
//        if allowCombinations {
//            for index in 0...6 {
//                // 0, 1, 2 = first should be true if true
//                // 3, 4, 5 = first should be false
//                // 6 = first should be true
//                // 0 = second should be false if true
//                // 1, 2, 3, 4 = second shoule be true if true
//                // 5, 6 = second should be false if true
//                // 0, 1 = third should be false if true
//                // 2 = third should be true if true
//                // 3 = third should be false if true
//                // 4, 5, 6 = third should be true if true
//                // Create the filter
//                let filterOptions = AnalyticsFilterOptions(
//                                    pitchThrown: pitchThrown,
//                                    pitcher: pitcher,
//                                    strikeZone: zone,
//                    withPlayerOnFirst: first != nil && first! ? index/3 == 0 && index > 6 && first! : nil,
//withPlayerOnSecond: second != nil && second! ? second! && index != 0 && index != 6 && index != 5: nil,
//    withPlayerOnThird: third != nil && third! ? third! && index != 0 && index != 1 && index != 3 : nil,
//                                    numberBalls: numBalls,
//                                    numberStrikes: numStrikes)
//                numberOfPitches += analytics.getTotal(withOptions: filterOptions)
//            }
//        } else {
            // Create the filter
            let filterOptions = AnalyticsFilterOptions(pitchThrown: pitchThrown,
                                                    pitcher: pitcher,
                                                    hitter: hitter,
                                                    strikeZone: zone,
                                                    withPlayerOnFirst: first,
                                                    withPlayerOnSecond: second,
                                                    withPlayerOnThird: third,
                                                    numberBalls: numBalls,
                                                    numberStrikes: numStrikes,
                                                    pitcherHand: pitchingHand)
            // Get the number of pitches
            numberOfPitches =
                analytics.getTotal(withOptions: filterOptions)
      //  }
       

        // Return the zone summary
        return numberOfPitches
    }
    
    
    func calculateTotalFastballBasesEmpty(
                         withGameViewModel gameViewModel : GameViewModel,
                         withStrikes strikes: Int,
                         withBalls balls: Int,
                         forPitcher pitcher : MemberInGame?=nil,
                         forHitter hitter: MemberInGame?=nil,
                        withPitchingHand pitchingHand: HandUsed? = nil) -> Int {
        // Create the analytics instance
        let analytics = ZoneAnalytics(withGameSnapshots:
                                        gameViewModel.gameSnapshots)
        let filterOptions = AnalyticsFilterOptions(pitchThrown: .Fastball,
                                                pitcher: pitcher,
                                                hitter: hitter,
                                                withPlayerOnFirst: false,
                                                withPlayerOnSecond: false,
                                                withPlayerOnThird: false,
                                                numberBalls: balls,
                                                numberStrikes: strikes,
                                                pitcherHand: pitchingHand)
        let numberOfPitches = analytics.getTotal(withOptions: filterOptions)
        
        return numberOfPitches
    }
    
    func calculateTotalFastballRunnerFirst(
                        withGameViewModel gameViewModel : GameViewModel,
                                     withStrikes strikes: Int,
                                     withBalls balls: Int,
                                     forPitcher pitcher : MemberInGame?=nil,
        forHitter hitter: MemberInGame?=nil,
       withPitchingHand pitchingHand: HandUsed? = nil) -> Int {
        // Create the analytics instance
        let analytics = ZoneAnalytics(withGameSnapshots:
                                        gameViewModel.gameSnapshots)
        let filterOptions = AnalyticsFilterOptions(pitchThrown: .Fastball,
                                                pitcher: pitcher,
                                                hitter: hitter,
                                                withPlayerOnFirst: false,
                                                withPlayerOnSecond: false,
                                                withPlayerOnThird: false,
                                                numberBalls: balls,
                                                numberStrikes: strikes,
                                                pitcherHand: pitchingHand)
        let numberOfPitches = analytics.getTotal(withOptions: filterOptions)
        
        return numberOfPitches
    }
    
}
