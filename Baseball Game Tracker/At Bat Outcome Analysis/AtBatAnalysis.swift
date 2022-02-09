// Copyright 2021-Present Benjamin Hilger

import Foundation

class AtBatAnalysis {
    
    static func getAtBatResult(forLastSnapshots snasphot: GameSnapshot,
                               withHitter hitter: MemberInGame,
                               useLongDescriptions longDesc: Bool = true) -> String {
        
        // Check if the last snapshot resulted in a pitch
        if let pitch = snasphot.eventViewModel.pitchEventInfo?.completedPitch {
            // Check if strikeout
            if snasphot.eventViewModel.numStrikes == 3 && (pitch.pitchResult?.isStrike() ?? false) {
                return longDesc ? "\(hitter.member.getFullName()) struckout \(pitch.pitchResult?.isStrikeSwinging() ?? false ? "swinging" : "looking") on a \(getPitchInfo(withPitch: pitch))" : "\(pitch.pitchResult?.isStrikeSwinging() ?? false ? "Strikeout\nSwinging" : "Strikeout\nLooking")"
            // Check if walk
            } else if snasphot.eventViewModel.numBalls == 4 && pitch.pitchResult?.isBall() ?? false {
                return longDesc ? "\(hitter.member.getFullName()) walked on a \(getPitchInfo(withPitch: pitch))" : "Walk"
            // Check if they advanced on an error
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedToSecondError) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedToThirdError) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedHomeError) ?? false) {
                return longDesc ? "\(hitter.member.getFullName()) advanced to \(getBaseAdvancedTo(withBIPHits: snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit ?? []).getBaseString()) on an error" : "Adv to \(getBaseAdvancedTo(withBIPHits: snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit ?? []).getBaseString()) on error"
            // Check if they were safe on a fielders choice error
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoice) ?? false || snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoiceOut) ?? false) &&
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.Error) ?? false {
                return longDesc ? "\(hitter.member.getFullName()) was safe at first by an fielder's choice error" : "FC Error"
            // Check if they were safe on a fielders choice with no error
            } else if pitch.pitchResult == .BIP &&
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoice) ?? false || snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoiceOut) ?? false {
                return longDesc ? "\(hitter.member.getFullName()) grounded into a fielder's choice on a \(pitch.pitchVelo != 0 ? "\(pitch.pitchVelo) MPH" : "") \(pitch.pitchResult != nil ? pitch.pitchResult?.getPitchOutcomeString() ?? "" : ""). \(getPlayerOutOnFieldersChoice(withSnapshot: snasphot) != nil ? "\(getPlayerOutOnFieldersChoice(withSnapshot: snasphot)?.member.getFullName() ?? "") was out on the play" : "")" : "FC"
            // Check if they reached on error
            } else if pitch.pitchResult == .BIP &&
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.Error) ?? false {
                return longDesc ? "\(hitter.member.getFullName()) reached on an error" : "Reached on Error"
            // Check if they had a single, double, triple, or HR
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FirstB) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.SecondB) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.ThirdB) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.HR) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.HRInPark) ?? false) {
                return longDesc ? "\(hitter.member.getFullName()) hit a \(getBaseDescriptor(withBIPHits: snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit ?? []).lowercased()) \(pitch.ballFieldLocation != nil ? " to\(pitch.ballFieldLocation?.getShortDescription() ?? "")" : "") on a \(getPitchInfo(withPitch: pitch))" : "\(getBaseDescriptor(withBIPHits: snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit ?? []))"
            // Check if there was a double or triple play
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.DoublePlay) ?? false ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.TriplePlay) ?? false) {
                return longDesc ? "\(hitter.member.getFullName()) hit into a \(snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.DoublePlay) ?? false ? "double" : "triple") play on a \(getPitchInfo(withPitch: pitch))" : "\(snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.DoublePlay) ?? false ? "Double" : "Triple") Play"
            // Check if the player was out with a specifed BIP type
            } else if pitch.pitchResult == .BIP && snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.OutAtFirst) ?? false &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .GB ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .LineDrive ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .FlyBall ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .Flare ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .HGB ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .PopFly ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .Bunt) {
                return longDesc ? "\(hitter.member.getFullName()) \(getBIPTypeDescriptor(withBIPType: snasphot.eventViewModel.pitchEventInfo?.selectedBIPType ?? .GB).lowercased()) out \(pitch.ballFieldLocation != nil ? "to \(pitch.ballFieldLocation?.getShortDescription() ?? "")" : "") on a \(getPitchInfo(withPitch: pitch))" : "\(getBIPTypeDescriptor(withBIPType: snasphot.eventViewModel.pitchEventInfo?.selectedBIPType ?? .GB)) Out"
            } else if pitch.bipHit.contains(.SacFly) {
                return longDesc ? "\(hitter.member.getFullName()) out on sac fly": "Sac Fly"
            } else {
                switch pitch.pitchResult {
                case .BatterInter:
                    return longDesc ? "\(hitter.member.getFullName()) out on batter interference" : "Batter Interference"
                case .CatcherInter:
                    return longDesc ? "\(hitter.member.getFullName()) sent to first on a catcher interference" : "Catcher Interference"
                case .some(.HBP):
                    return longDesc ? "\(hitter.member.getFullName()) was HBP" : "HBP"
                default:
                    return longDesc ? hitter.member.getFullName() : ""
                }
            }
        } else if snasphot.eventViewModel.pitchEventInfo?.selectedPitchOutcome == .IntentionalBall {
            return longDesc ? "\(hitter.member.getFullName()) was walked intentionally" : "Intentional Walk"
        }
        return longDesc ? hitter.member.getFullName() : ""
    }
    
    static func isEndOfAtBatt(forLastSnapshots snasphot: GameSnapshot,
                               withHitter hitter: MemberInGame) -> Bool {
        
        // Check if the last snapshot resulted in a pitch
        if let pitch = snasphot.eventViewModel.pitchEventInfo?.completedPitch {
            // Check if strikeout
            if snasphot.eventViewModel.numStrikes == 3 && (pitch.pitchResult?.isStrike() ?? false) {
                return true
            // Check if walk
            } else if snasphot.eventViewModel.numBalls == 4 && pitch.pitchResult?.isBall() ?? false {
                return true
            // Check if they advanced on an error
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedToSecondError) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedToThirdError) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.AdvancedHomeError) ?? false) {
                return true
            // Check if they were safe on a fielders choice error
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoice) ?? false || snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoiceOut) ?? false) &&
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.Error) ?? false {
                return true
            // Check if they were safe on a fielders choice with no error
            } else if pitch.pitchResult == .BIP &&
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoice) ?? false || snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FielderChoiceOut) ?? false {
                return true
            // Check if they reached on error
            } else if pitch.pitchResult == .BIP &&
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.Error) ?? false {
                return true
            // Check if they had a single, double, triple, or HR
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.FirstB) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.SecondB) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.ThirdB) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.HR) ?? false ||
                        snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.HRInPark) ?? false) {
                return true
            // Check if there was a double or triple play
            } else if pitch.pitchResult == .BIP &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.DoublePlay) ?? false ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.TriplePlay) ?? false) {
                return true
            // Check if the player was out with a specifed BIP type
            } else if pitch.pitchResult == .BIP && snasphot.eventViewModel.pitchEventInfo?.selectedBIPHit.contains(.OutAtFirst) ?? false &&
                        (snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .GB ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .LineDrive ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .FlyBall ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .Flare ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .HGB ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .PopFly ||
                            snasphot.eventViewModel.pitchEventInfo?.selectedBIPType == .Bunt) {
                return true
            } else {
                switch pitch.pitchResult {
                case .BatterInter:
                    return true
                case .CatcherInter:
                    return true
                case .some(.HBP):
                    return true
                default:
                    return false
                }
            }
        } else if snasphot.eventViewModel.pitchEventInfo?.selectedPitchOutcome == .IntentionalBall {
            return true
        }
        return false
    }
    
    private static func getBIPTypeDescriptor(withBIPType type: BIPType) -> String {
        switch type {
        case .Bunt:
            return "Bunted"
        case .Flare:
            return "Flared"
        case .FlyBall:
            return "Fly"
        case .GB, .HGB:
            return "Grounded"
        case .LineDrive:
            return "Lined"
        case .PopFly:
            return "Popped"
        }
    }
    
    private static func getPitchInfo(withPitch pitch: Pitch) -> String {
        return "\(pitch.pitchResult != nil ? pitch.pitchType?.getPitchTypeString() ?? "" : "" )"
    }
    
    private static func getBaseDescriptor(withBIPHits hits: [BIPHit]) -> String {
        if hits.contains(.FirstB) {
            return "Single"
        } else if hits.contains(.SecondB) {
            return "Double"
        } else if hits.contains(.ThirdB) {
            return "Triple"
        } else if hits.contains(.HR) || hits.contains(.HRInPark) {
            return "Home Run"
        }
        return ""
    }

    private static func getBaseAdvancedTo(withBIPHits hits: [BIPHit]) -> Base {
        if hits.contains(.AdvancedToSecondError) {
            return .Second
        } else if hits.contains(.AdvancedToThirdError) {
            return .Third
        } else if hits.contains(.AdvancedHomeError) {
            return .Home
        }
        return Base.First
    }
    
    private static func getPlayerOutOnFieldersChoice(withSnapshot snapshot: GameSnapshot) -> MemberInGame? {
        // Explore all of the base path events
        for event in snapshot.eventViewModel.basePathInfo {
            // Check if the type was an out
            if event.type == .OutonBasePath {
                // Return the player
                return event.runnerInvolved
            }
        }
        return nil
    }
    
    
    
}
