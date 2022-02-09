// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct HitterInformationView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    @State var viewSheet: Bool = false
    @State var viewActionSheet: Bool = false
    
    var body: some View {
        if let hitter = gameViewModel.getCurrentHitter() {
            GeometryReader { geometry in
                HStack {
                    HStack {
                        Text("\(gameViewModel.getCurrentHitter()?.member.getFullName() ?? "")  #\(Int(gameViewModel.getCurrentHitter()?.member.uniformNumber ?? 0))").padding()
                        Spacer()
                        Text("\(gameViewModel.currentHittingHand == .Left ? "LH" : "RH")H").padding().border(Color.black, width: 1)
                    }.frame(width: UIScreen.main.bounds.width*0.5).border(Color.black, width: 1).padding(.top).padding(.bottom).position(x: geometry.size.width*0.75, y: geometry.size.height*0.8)
                    .actionSheet(isPresented: $viewActionSheet, content: {
                        return ActionSheet(title: Text("Hitter Options"), buttons: generateActionOptions())
                    })
                    .sheet(isPresented: $viewSheet, content: {
                        LiveLineupChangeView(editingAwayTeam: (gameViewModel.currentInning?.isTop ?? false), state: .Hitter)
                            .environmentObject(gameViewModel)
                            .environmentObject(LineupViewModel(withLineup: gameViewModel.lineup, withCurrentHitter: hitter))
                    })
                    .onTapGesture {
                        self.viewActionSheet = true
                    }
                }
            }
        }
        
    }
    
    func generateActionOptions() -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        
        // Add button to select a pinch hitter
        buttons.append(Alert.Button.default(Text("Pinch Hitter"), action: {
            self.viewSheet = true
        }))
        
        // Add button to change the hitting hand
        buttons.append(Alert.Button.default(Text("Change Hitting Hand to \(gameViewModel.currentPitchingHand == .Left ? "Right" : "Left")"), action: {
            self.gameViewModel.currentHittingHand = gameViewModel.currentHittingHand == .Left ? .Right : .Left
        }))
        
        return buttons
    }
}
