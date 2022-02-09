// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct LineupView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var lineupViewModel : LineupViewModel
    
    @State var viewEditLineup : Bool = false
    @State var isAddingPlayer : Bool = false
    
    //@State var currentLineup : [MemberInGame] = []
    
    @State var truePosition : Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            if let game = gameViewModel.game, let inning = gameViewModel.currentInning, let hitter = gameViewModel.currentHitter {
                HStack {
                    VStack {
                        Text("Hitting Roster")
                            .padding()
                        List {
                            ForEach(0..<lineupViewModel.getCurrentLineupEditing(editingAwayLineup: inning.isTop).count,
                                    id: \.self) { index in
                                if lineupViewModel.getCurrentLineupEditing(
                                    editingAwayLineup: inning.isTop)[index].positionInGame != .DH {
                                    HStack {
                                            LineupListCellView(
                                                player: lineupViewModel.getCurrentLineupEditing(editingAwayLineup: inning.isTop)[index],
                                                               editingAwayTeam:
                                                                inning.isTop,
                                                               positionInLineup:
                                                                getPosition(forPlayer: lineupViewModel.getCurrentLineupEditing(editingAwayLineup: inning.isTop)[index]),
                                                               isEditable: false,
                                                               viewingType:
                                                                    .HittingLineup)
                                                .environmentObject(lineupViewModel)
                                    }.padding()
                                    .if((inning.isTop ? gameViewModel.lineup.curentAwayTeamLineup : gameViewModel.lineup.currentHomeTeamLineup)[index] == hitter || (inning.isTop ? gameViewModel.lineup.curentAwayTeamLineup : gameViewModel.lineup.currentHomeTeamLineup)[index].dh == hitter.member) {
                                        $0.border(inning.isTop ?
                                                    game.awayTeam.teamPrimaryColor :
                                                    game.homeTeam.teamPrimaryColor, width: 1)
                                    }
                                }
                            }
                        }.border(Color.black, width: 1)
                        LineupEditOptionsView()
                            .environmentObject(gameViewModel)
                            .environmentObject(lineupViewModel)
                            .frame(height: geometry.size.height * 0.2)
                    }.border(Color.black, width: 1)
                    .onReceive(lineupViewModel.$availableMemberSelected, perform: { _ in
                    }).onChange(of: gameViewModel.lineup.currentHomeTeamLineup) { _ in
                        lineupViewModel.awayRoster = gameViewModel.lineup.totalAwayTeamRoster
                        lineupViewModel.homeRoster = gameViewModel.lineup.totalHomeTeamRoster
                        lineupViewModel.awayLineup = gameViewModel.lineup.curentAwayTeamLineup
                        lineupViewModel.homeLineup = gameViewModel.lineup.currentHomeTeamLineup
                    }.onChange(of: gameViewModel.lineup.currentHomeTeamLineup, perform: { _ in
                        lineupViewModel.awayRoster = gameViewModel.lineup.totalAwayTeamRoster
                        lineupViewModel.homeRoster = gameViewModel.lineup.totalHomeTeamRoster
                        lineupViewModel.awayLineup = gameViewModel.lineup.curentAwayTeamLineup
                        lineupViewModel.homeLineup = gameViewModel.lineup.currentHomeTeamLineup
                    })
                }
            }
        }
    }

    func getPosition(forPlayer player: MemberInGame) -> Int {
        var currentPosition = 1
        
        if let inning = gameViewModel.currentInning {
            for p in lineupViewModel.getCurrentLineupEditing(editingAwayLineup: inning.isTop) {
                if p == player {
                    return currentPosition
                } else if p.positionInGame != .DH {
                    currentPosition += 1
                }
            }
        }
        
        return 0
    }
    
    func attemptToAddPlayer(name : String, uniformNumber : Int, lastName : String) {
        if let inning = gameViewModel.currentInning, let game = gameViewModel.game {
            if inning.isTop {
                let newMember = Member(withID: "M0\(game.awayTeam.members.count)", withFirstName: name, withLastName: lastName, withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Right, withHittingHands:.Right)
                game.awayTeam.members.append(newMember)
                gameViewModel.lineup.totalAwayTeamRoster.append(MemberInGame(member: newMember, positionInGame: .Bench))
            } else {
                let newMember = Member(withID: "M0\(game.homeTeam.members.count)", withFirstName: name, withLastName: lastName, withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
                game.homeTeam.members.append(newMember)
                gameViewModel.lineup.totalHomeTeamRoster.append(MemberInGame(member: newMember, positionInGame: .Bench))
            }
        }
    }
    
}

struct LineupEditOptionsView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var lineupViewModel : LineupViewModel
    
    @State var viewEditLineup : Bool = false
    @State var isAddingPlayer : Bool = false
    
    
    var body: some View {
        VStack {
            Button(action: {
                viewEditLineup = true
            }, label: {
                Text("Edit Lineup")
            }).padding(10).border(Color.black, width: 1)
            .sheet(isPresented: $viewEditLineup) {
                LineupEditTabView()
                    .environmentObject(gameViewModel)
                    .environmentObject(lineupViewModel)
            }
            Button {
                isAddingPlayer = true
            } label: {
                Text("Add Player")
            }.padding().border(Color.black, width: 1).padding(.bottom)
            .navigationBarTitle("").navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }.alert(isPresented: $isAddingPlayer, TextAlert(title: "Add Player", placeholder: "Player First Name", secondPlaceholder: "Player Last Name", thirdPlaceholder: "Uniform Number", action: { (input, lastName, numberInput) in
            if let name = input, name != "", let numberInput = numberInput, let uniformNumber = Int(numberInput), let lastName = lastName, lastName != "" {
                attemptToAddPlayer(name: name,
                                   uniformNumber: uniformNumber,
                                   lastName: lastName)
            }
        }))
        .padding(8)
    }
    
    func attemptToAddPlayer(name : String, uniformNumber : Int, lastName : String) {
        if let inning = gameViewModel.currentInning, let game = gameViewModel.game {
            if inning.isTop {
                let newMember = Member(withID: "M0\(game.awayTeam.members.count)", withFirstName: name, withLastName: lastName, withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Right, withHittingHands:.Right)
                game.awayTeam.members.append(newMember)
                gameViewModel.lineup.totalAwayTeamRoster.append(MemberInGame(member: newMember, positionInGame: .Bench))
            } else {
                let newMember = Member(withID: "M0\(game.homeTeam.members.count)", withFirstName: name, withLastName: lastName, withNickname: "", withHeight: 0, withHighSchool: "", withHometown: "", withPositions: [], withWeight: 0, withBio: "", withRole: 0, withThrowingHands: .Right, withHittingHands: .Right)
                game.homeTeam.members.append(newMember)
                gameViewModel.lineup.totalHomeTeamRoster.append(MemberInGame(member: newMember, positionInGame: .Bench))
            }
        }
    }
}

extension UIAlertController {
    convenience init(alert: TextAlert) {
        self.init(title: alert.title, message: nil, preferredStyle: .alert)
        addTextField { $0.placeholder = alert.placeholder }
        addTextField { $0.placeholder = alert.secondPlaceholder }
        addTextField { $0.placeholder = alert.thirdPlaceholder }
        addAction(UIAlertAction(title: alert.cancel, style: .cancel) { _ in
            alert.action(nil, nil, nil)
        })
        let textField = self.textFields?[0]
        let lastNameField = self.textFields?[1]
        let numberField = self.textFields?[2]
        addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            alert.action(textField?.text, lastNameField?.text, numberField?.text)
        })
    }
}



struct AlertWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alert: TextAlert
    let content: Content
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }
    
    final class Coordinator {
        var alertController: UIAlertController?
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<AlertWrapper>) {
        uiViewController.rootView = content
        if isPresented && uiViewController.presentedViewController == nil {
            var alert = self.alert
            alert.action = {
                self.isPresented = false
                self.alert.action($0, $1, $2)
            }
            context.coordinator.alertController = UIAlertController(alert: alert)
            uiViewController.present(context.coordinator.alertController!, animated: true)
        }
        if !isPresented && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
}

public struct TextAlert {
    public var title: String
    public var placeholder: String = ""
    public var secondPlaceholder : String = ""
    public var thirdPlaceholder : String = ""
    public var accept: String = "OK"
    public var cancel: String = "Cancel"
    public var action: (String?, String?, String?) -> ()
}

extension View {
    public func alert(isPresented: Binding<Bool>, _ alert: TextAlert) -> some View {
        AlertWrapper(isPresented: isPresented, alert: alert, content: self)
    }
}
