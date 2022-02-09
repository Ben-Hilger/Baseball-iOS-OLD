// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct GameNavigation: View {
    
    @Environment(\.presentationMode) var presentation
    /// Stores informaiton about the season
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    //@EnvironmentObject var teamViewModel : TeamViewModel
    //@State var lineupViewModel : LineupViewModel = LineupViewModel(withLineup: Lineup(withAwayMembers: [], withHomeMembers: []))
    
    @State var game : Game?
    /// Stores all of the state avbbreviations
    var stateAbbr = ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    /// Stores the index of the selected state
    @State private var selectedState = 0
    /// Stores the index of the selected home team
    @State private var selectedTeam = 0
    /// Stores the index of the selected away team
    @State private var selectedAwayTeam = 0
    /// Stores the game date and start time information
    @State private var selectedDate = Date()
    /// Stores the inputted city information
    @State private var cityLocation = ""
    /// Stores the flag to control if to alert the user inputting an invalid city
    @State private var invalidCity = false
    /// Stores the action state of the view for activating the navigation link
    @State private var action : Int? = 0
    
    var body: some View {
        // Checks if there's a valid season
        NavigationView {
            if let seasonIndex = seasonViewModel.currentSeasonIndex {
                VStack {
    //                Text("Game Creation")
    //                    .font(.largeTitle)
                    List {
                        // Allows the user to select the home team
                        HStack {
                            Text("Home Team:")
                            Picker(selection: $selectedTeam, label: Text("Home Team"), content: {
                                ForEach(0..<seasonViewModel.seasons[seasonIndex].teams.count) {
                                    Text(verbatim: seasonViewModel.seasons[seasonIndex].teams[$0].teamName)
                                }
                            }).frame(width: UIScreen.main.bounds.width/2, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(maxWidth: .infinity)
                        // Allows the user to select the away team
                        HStack {
                            Text("Away Team:")
                            Picker(selection: $selectedAwayTeam, label: Text("Home Team"), content: {
                                ForEach(0..<seasonViewModel.seasons[seasonIndex].teams.count) {
                                    Text(verbatim: seasonViewModel.seasons[seasonIndex].teams[$0].teamName)
                                }
                            }).frame(width: UIScreen.main.bounds.width/2, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.frame(maxWidth: .infinity)
                        // Allows the user to set the game start date and time
                        VStack {
                            DatePicker("Game Date and Start Time:", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                .padding()
                                .border(Color.black, width: 3)
                            HStack {
                                Text("City:")
                                Spacer()
                                TextField("Oxford", text: $cityLocation)
                                    .padding()
                                    .border(self.invalidCity ? Color.red : Color.black, width: 3)
                        
                            }.padding()
                            HStack {
                                Text("State:")
                                Picker(selection: $selectedState, label: Text("Game State Location"), content: {
                                    ForEach(0 ..< stateAbbr.count) {
                                        Text(verbatim: self.stateAbbr[$0])
                                    }
                                }).frame(width: UIScreen.main.bounds.width/2, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                       
                            }.padding().border(Color.black, width: 3)
                        }
                        // Allows the user to move to the next view in the game creation process
                        HStack {
                            Button(action: {
                                // Checks if the user inputted a city
                                if cityLocation != "" {
                                    if (selectedTeam < 0 || selectedTeam >= seasonViewModel.seasons[seasonIndex].teams.count) ||
                                        (selectedAwayTeam < 0 || selectedAwayTeam >= seasonViewModel.seasons[seasonIndex].teams.count ) ||
                                        (selectedState < 0 || selectedState >= stateAbbr.count)
                                    {
                                        return
                                    }
                                    // Gets the game information from the user
                                    let homeTeam = seasonViewModel.seasons[seasonIndex].teams[selectedTeam]
                                    let awayTeam = seasonViewModel.seasons[seasonIndex].teams[selectedAwayTeam]
                                    let start = selectedDate
                                    let city = cityLocation
                                    let state = stateAbbr[selectedState]
                                    seasonViewModel.gameAdding = Game(withGameID: "", withAwayTeam: awayTeam, withHomeTeam: homeTeam, withDate: start, withCity: city, withState: state)
                                    seasonViewModel.gameAdding?.seasonID = seasonViewModel.seasons[seasonIndex].seasonID
                                    seasonViewModel.lineupEditing.awayRoster = []
                                    seasonViewModel.lineupEditing.homeLineup = []
                                    for awayMember in awayTeam.members {
                                        seasonViewModel.lineupEditing.awayRoster.append(MemberInGame(member: awayMember, positionInGame: .Bench))
                                    }
                                    for homeMember in homeTeam.members {
                                        seasonViewModel.lineupEditing.homeRoster.append(MemberInGame(member: homeMember, positionInGame: .Bench))
                                    }
                                    // Updates the action to activate the navigation link
                                    self.action = 1
                                } else {
                                    // Sets the invalid city flag to true to inform the user
                                    self.invalidCity = true
                                }

                            }, label: {
                                Text("Next")
                                    .padding()
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            })
                            NavigationLink(destination: GameCreateSetLineupTabView() {
                                self.presentation.wrappedValue.dismiss()
                            }
                            //        .environmentObject(lineupViewModel)
                                    .environmentObject(seasonViewModel),
                                    //.environmentObject(LineupViewModel(withLineup: self.)
                                tag: 1,
                                selection: $action,
                                label: {
                                    EmptyView()
                                })
                        }.border(Color.blue, width: 3)
                    }
                    .alert(isPresented: $invalidCity, content: {
                        Alert(title: Text("Missing City"), message: Text("Please enter a valid city before continuing"), dismissButton: .cancel(Text("Ok")))
                    })
                    .navigationBarTitle("Game Create", displayMode: .inline)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

enum CurrentState {
    case GameInfo
    case Lineup
}

