// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct AnalyticsReportView: View {
    
    @EnvironmentObject var gameViewModel : GameViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    
    @State var reportViewing : ReportViewing = .None
    @State var isViewingSheet : Bool = false
    
    var body: some View {
        VStack {
            AnalyticsReportViewList()
                .environmentObject(gameViewModel)
                .environmentObject(settingsViewModel)
            .navigationBarTitle("").navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct AnalyticsReportViewList: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State var reportViewing : ReportViewing = .None
    @State var isViewingSheet : Bool = false
    var body: some View {
        List {
            Button(action: {
                reportViewing = .BoxScore
                isViewingSheet = true
            }, label: {
                Text("Box Score")
            })
            if SettingsViewModel.isInTestMode {
                Button(action: {
                    reportViewing = .Diag
                    isViewingSheet = true
                }, label: {
                    Text("Diagnostics")
                })
            }
            Button(action: {
                reportViewing = .PitchTendencies
                isViewingSheet = true
            }, label: {
                Text("Pitch Tendencies")
            })
            Button(action: {
                reportViewing = .PitchingChart
                isViewingSheet = true
            }, label: {
                Text("Pitching Chart")
            })
//            Button(action: {
//                for snapshot in gameViewModel.gameSnapshots {
//                    MongoDBConversion.convertGameSnapshot(gameSnapshot: snapshot)
//                }
//            }, label: {
//                Text("Convert to new data structure")
//            })
        }.sheet(isPresented: $isViewingSheet, content: {
            if reportViewing == .BoxScore {
                BoxScoreView()
                    .environmentObject(gameViewModel)
                    .environmentObject(settingsViewModel)
            } else if reportViewing == .Diag {
                DiagnosticsView()
                    .environmentObject(gameViewModel)
            } else if reportViewing == .PitchTendencies {
                PitchTendenciesTabView()
                    .environmentObject(gameViewModel)
                    .environmentObject(PitchTendenciesViewModel())
            } else if reportViewing == .PitchingChart {
                PitchingChartReportLoaderView()
                    .environmentObject(gameViewModel)
            }
            
        })
    }
}

enum ReportViewing {
    case BoxScore
    case Diag
    case PitchTendencies
    case PitchingChart
    case None
}

struct ReportOptionsView : View {
    
    @ObservedObject var viewModel : AnalyticsReportsViewModel
    
    var body: some View {
        Button(action: {
            viewModel.isViewingSheet = true
            viewModel.reportViewing = .BoxScore
        }, label: {
            Text("Box Score")
        })
        Button(action: {
            viewModel.isViewingSheet = true
            viewModel.reportViewing = .Diag
        }, label: {
            Text("Diagnostics")
        })
        Button(action: {
            viewModel.isViewingSheet = true
            viewModel.reportViewing = .PitchTendencies
        }, label: {
            Text("Pitch Tendencies")
        })
    }
}

class AnalyticsReportsViewModel : ObservableObject {
    
    @Published var isViewingSheet: Bool = false
    @Published var reportViewing: ReportViewing = .BoxScore
    
}
