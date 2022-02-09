//
//  HandSelectionView.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/2/21.
//

import SwiftUI

struct HandSelectionView: View {
    
//    @EnvironmentObject var firebaseLifecycle: FirebaseLifecycle
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Pitching Hand")
                HStack {
                    Button(action: {
                        gameViewModel.currentPitchingHand = .Left
                    }, label: {
                        Text("Left")
                            .padding()
                            .border(getBorderColor(forHand: .Left, forPlayer: .Pitcher), width: 3)
                            .foregroundColor(getBorderColor(forHand: .Left, forPlayer: .Pitcher))
                    })
                    Button(action: {
                        gameViewModel.currentPitchingHand = .Right
                    }, label: {
                        Text("Right")
                            .padding()
                            .border(getBorderColor(forHand: .Right, forPlayer: .Pitcher), width: 3)
                            .foregroundColor(getBorderColor(forHand: .Right, forPlayer: .Pitcher))
                    })
                }
                Text("Hitting Hand")
                HStack {
                    Button(action: {
                        gameViewModel.currentHittingHand = .Left
                    }, label: {
                        Text("Left")
                            .padding()
                            .border(getBorderColor(forHand: .Left, forPlayer: .Hitter), width: 3)
                            .foregroundColor(getBorderColor(forHand: .Left, forPlayer: .Hitter))
                    })
                    Button(action: {
                        gameViewModel.currentHittingHand = .Right
                    }, label: {
                        Text("Right")
                            .padding()
                            .border(getBorderColor(forHand: .Right, forPlayer: .Hitter), width: 3)
                            .foregroundColor(getBorderColor(forHand: .Right, forPlayer: .Hitter))
                    })
                }
                Text("Pitching style")
                HStack {
                    Button(action: {
                        gameViewModel.currentPitchingStyle = .Stretch
                    }, label: {
                        Text("Str")
                            .padding()
                            .border(getBorderColor(forPitchingStyle: .Stretch), width: 3)
                            .foregroundColor(getBorderColor(forPitchingStyle: .Stretch))
                    })
                    Button(action: {
                        gameViewModel.currentPitchingStyle = .Windup
                    }, label: {
                        Text("Wind")
                            .padding()
                            .border(getBorderColor(forPitchingStyle: .Windup), width: 3)
                            .foregroundColor(getBorderColor(forPitchingStyle: .Windup))
                    })
                }
            }.position(x: geometry.size.width * getXModifier(), y: geometry.size.height * getYModifier())
            
        }
    }
    
    func getXModifier() -> CGFloat {
        return settingsViewModel.handMode == .Right ? 0.1 : 0.9
    }
    
    func getYModifier() -> CGFloat {
        return 0.75
    }
    
    func getBorderColor(forHand hand: HandUsed, forPlayer player: PersonEditing) -> Color {
        if player == .Pitcher {
            return hand == gameViewModel.currentPitchingHand ? Color.blue : Color.black
        } else {
            return hand == gameViewModel.currentHittingHand ? Color.blue : Color.black
        }
    }
    
    func getBorderColor(forPitchingStyle style: PitchingStyle) -> Color {
        return style == gameViewModel.currentPitchingStyle ? Color.blue :
            Color.black
    }
}
