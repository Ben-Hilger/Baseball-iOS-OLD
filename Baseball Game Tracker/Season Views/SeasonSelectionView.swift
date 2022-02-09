// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct SeasonSelectionView: View {

    @EnvironmentObject var seasonsViewModel : SeasonViewModel
    //@EnvironmentObject var teamViewModel : TeamViewModel
    
    @State var state : Int?
    
    @State var viewAddSeason : Bool = false
    
    var body: some View {
        VStack(alignment: .center, content: {
            HStack {
                Text("Season Selection")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 25))
                Button(action: {
                    viewAddSeason = true
                }, label: {
                    Image(systemName: "plus.rectangle.fill")
                        .font(.system(size: 25))
                        .frame(alignment: .leading)
                }).sheet(isPresented: $viewAddSeason, content: {
                    SeasonCreationView()
                        .environmentObject(seasonsViewModel)
                })
            }
            
            List {
                ForEach(seasonsViewModel.seasons) { season in
                    HStack {
                        Button(action: {
                            seasonsViewModel.setCurrentSeason(
                                seasonToSet: season)
                            self.state =
                                seasonsViewModel.seasons.firstIndex(
                                    of: season)
                                ?? 1
                        }, label: {
                            Text(season.getFullSeasonName())
                                .multilineTextAlignment(.leading)
                        })
                        NavigationLink(
                            destination: SeasonTabView()
                                .environmentObject(seasonsViewModel),
                            tag:
                                seasonsViewModel.seasons.firstIndex(of: season)
                                ?? 1,
                            selection: $state,
                            label: {
                                EmptyView()
                            })
                    }
                }
            }
            .frame(alignment: .center)
            .navigationBarTitle("")
            .navigationViewStyle(StackNavigationViewStyle())
        }).padding()
//        .navigationBarTitle("Season Selection", displayMode: .inline)
//        .navigationBarItems(trailing: Button(action: {
//            viewAddSeason = true
//        }, label: {
//            Image(systemName: "plus.rectangle.fill")
//                .font(.system(size: 25))
//                .frame(alignment: .leading)
//        }).sheet(isPresented: $viewAddSeason, content: {
//            SeasonCreationView()
//                .environmentObject(seasonsViewModel)
//        }))
    }
}

