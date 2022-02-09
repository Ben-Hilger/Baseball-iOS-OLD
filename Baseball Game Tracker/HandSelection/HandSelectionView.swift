//
//  HandSelectionView.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/2/21.
//

import SwiftUI

struct HandSelectionView: View {
    
    @EnvironmentObject var firebaseLifecycle: FirebaseLifecycle
    //@EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Pitching Hand")
                HStack {
                    Button(action: {
                        firebaseLifecycle.selectedGame.currentPitchingHand = .Left
                        firebaseLifecycle.objectWillChange.send()
                    }, label: {
                        Text("Left")
                            .padding()
                            .border(getBorderColor(forHand: .Left, forPlayer: .Pitcher), width: 3)
                            .foregroundColor(getBorderColor(forHand: .Left, forPlayer: .Pitcher))
                    })
                    Button(action: {
                        firebaseLifecycle.selectedGame.currentPitchingHand = .Right
                        firebaseLifecycle.objectWillChange.send()
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
                        firebaseLifecycle.selectedGame.currentHittingHand = .Left
                        firebaseLifecycle.objectWillChange.send()
                    }, label: {
                        Text("Left")
                            .padding()
                            .border(getBorderColor(forHand: .Left, forPlayer: .Hitter), width: 3)
                            .foregroundColor(getBorderColor(forHand: .Left, forPlayer: .Hitter))
                    })
                    Button(action: {
                        firebaseLifecycle.selectedGame.currentHittingHand = .Right
                        firebaseLifecycle.objectWillChange.send()
                    }, label: {
                        Text("Right")
                            .padding()
                            .border(getBorderColor(forHand: .Right, forPlayer: .Hitter), width: 3)
                            .foregroundColor(getBorderColor(forHand: .Right, forPlayer: .Hitter))
                    })
                }
            }.position(x: geometry.size.width * getXModifier(), y: geometry.size.height * getYModifier())
            
        }
    }
    
    func getXModifier() -> CGFloat {
        return settingsViewModel.handMode == .Right ? 0.15 : 0.85
    }
    
    func getYModifier() -> CGFloat {
        return 0.8
    }
    
    func getBorderColor(forHand hand: HandUsed, forPlayer player: PersonEditing) -> Color {
        if player == .Pitcher {
            return hand == firebaseLifecycle.selectedGame.currentPitchingHand ? Color.blue : Color.black
        } else {
            return hand == firebaseLifecycle.selectedGame.currentHittingHand ? Color.blue : Color.black
        }
    }
}
