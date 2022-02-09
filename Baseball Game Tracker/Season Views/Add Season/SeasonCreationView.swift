// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SeasonCreationView: View {
    
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var seasonViewModel : SeasonViewModel
    @EnvironmentObject var teamViewModel : TeamViewModel
    
    var seasonsToSelect = ["Winter", "Spring", "Summer", "Fall"]
    
    @State var seasonSelected : String = "Winter"
    @State var yearSelected : String = "\(Calendar.current.component(.year, from: Date()))"
    
    @State var state : Int? = 0
    
    var currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Season Creation")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.system(size: 25))
                Picker("", selection: $seasonSelected) {
                    ForEach(0..<seasonsToSelect.count, id: \.self) { index in
                        Text(seasonsToSelect[index]).tag(seasonsToSelect[index])
                    }
                }.border(Color.black, width: 3)
                Picker("", selection: $yearSelected) {
                    ForEach(currentYear-5...currentYear+5, id: \.self) { index in
                        Text("\(index)").tag("\(index)")
                    }
                }.border(Color.black, width: 3)
                Button(action: {
                    if let year = Int(yearSelected) {
//                        let newSeason = SeasonSaveManagement.createNewSeason(withSeasonName: seasonSelected, withSeasonYear: year)
                        let newSeason = Season(withSeasonID : "", withSeasonYear : year, withSeasonName : seasonSelected)
                        teamViewModel.addingToSeason = newSeason
                        self.state = 1
                    }
                }, label: {
                    Text("Next: Team Selection")
                        .padding()
                        .border(Color.blue, width: 3)
                })
                NavigationLink(
                    destination: AddTeamToSeasonView()
                        .environmentObject(seasonViewModel)
                        .environmentObject(teamViewModel),
                    tag: 1,
                    selection: $state,
                    label: {
                        EmptyView()
                    })
            }
        }
    }
}

struct SeasonCreationView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonCreationView()
    }
}
