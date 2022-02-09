// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitcherInformationView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    
    @State var viewSheet: Bool = false
    @State var viewActionSheet: Bool = false
    @State var viewHandStyleAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack {
                    Text("\(gameViewModel.getCurrentPitcher()?.member.getFullName() ?? "") #\(Int(gameViewModel.getCurrentPitcher()?.member.uniformNumber ?? 0)) (\(gameViewModel.currentPitchingStyle.getString()))").padding()
                    Spacer()
                    Text("\(gameViewModel.generatePitchTracker()[gameViewModel.getCurrentPitcher()?.member.memberID ?? ""] ?? 0) Pitch\((gameViewModel.generatePitchTracker()[gameViewModel.getCurrentPitcher()?.member.memberID ?? ""] ?? 0) == 1 ? "" : "es")")
                }
                Spacer()
                Text("\(gameViewModel.currentPitchingHand == .Left ? "LH" : "RH")P").padding().border(Color.black, width: 1)
            }.frame(width: UIScreen.main.bounds.width*0.5).border(Color.black, width: 1)
            .padding(.top)
            .padding(.bottom)
            .position(x: geometry.size.width*0.25, y: geometry.size.height*0.8)
//            .alert(isPresented: $viewActionSheet, content: {
//                return Alert(title: Text("Pither Options"),
//                    primaryButton: Alert.Button.default(Text("Change Pitcher"), action: {
//                    self.viewSheet = true
//                }), secondaryButton: Alert.Button.default(Text("Change Hand/Style"), action: {
//                    self.viewHandStyleAlert = true
//                }))
//            })
            .actionSheet(isPresented: $viewActionSheet, content: {
                return ActionSheet(title: Text("Pitcher Options"), buttons: generateActionOptions())
            })
            .sheet(isPresented: $viewSheet, content: {
                LiveLineupChangeView(editingAwayTeam: !(gameViewModel.currentInning?.isTop ?? false), state: .Fielder, position: .Pitcher)
                    .environmentObject(gameViewModel)
                    .environmentObject(LineupViewModel(withLineup: gameViewModel.lineup))
            })
            .onTapGesture {
                self.viewActionSheet = true
            }

        }
    }
    
    func generateActionOptions() -> [Alert.Button] {
        var buttons : [Alert.Button] = []
        
        // Add a button to change the pitcher
        buttons.append(Alert.Button.default(Text("Change Pitcher"), action: {
            self.viewSheet = true
        }))
        
        // Add a button to change the pitching hand
        buttons.append(Alert.Button.default(Text("Change Pitching Hand to \(gameViewModel.currentPitchingHand == .Left ? "Right" : "Left")"), action: {
            self.gameViewModel.currentPitchingHand = gameViewModel.currentPitchingHand == .Left ? .Right : .Left
        }))
        
        // Add a button to switch the pitching style
        buttons.append(Alert.Button.default(Text("Switch to \(gameViewModel.currentPitchingStyle == .Windup ? "Strech" : "Windup")"), action: {
            // Change the pitching style to Windup from Strech or Strech
            // from Windup
            gameViewModel.currentPitchingStyle =
                gameViewModel.currentPitchingStyle ==
                .Windup ? .Stretch : .Windup
        }))
        
        return buttons
    }
}
//
//struct OptionsView: View {
//
//    @EnvironmentObject var gameViewModel: GameViewModel
//
//    var personEditing: PersonEditing
//
//    @State var viewSheet: Bool = false
//    @State var viewActionSheet: Bool = false
//
//    var body: some View {
//        List {
//            Button(action: {
//                self.viewSheet = true
//            }, label: {
//                Text("Change \(personEditing == .Pitcher ?  "Pitcher" : "Hitter")")
//            })
//        }.sheet(isPresented: $viewSheet, content: {
//            if personEditing == .Pitcher {
//                LiveLineupChangeView(editingAwayTeam: !(gameViewModel.currentInning?.isTop ?? false), state: .Fielder, position: .Pitcher)
//                    .environmentObject(gameViewModel)
//                    .environmentObject(LineupViewModel(withLineup: gameViewModel.lineup))
//            } else if personEditing == .Hitter {
//
//            }
//        })
//    }
//}
