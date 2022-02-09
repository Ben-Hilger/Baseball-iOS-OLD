// Copyright 2021-Present Benjamin Hilger

import SwiftUI

struct PitchTendenciesHitterTab: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var pitchTendenciesViewModel: PitchTendenciesViewModel
    
    @State var playersViewing: [MemberInGame]
    
    var hitterTeam: GameTeamType
    
    @State var pdfView : PDFViewUI?
    @State var pdfFileLoc : URL?
    @State var showPDF : Bool = true
  
    var pdfMode: Bool = false
    
    var body: some View {
        TabView {
            if let pdfView: PDFViewUI = pdfView, showPDF {
                HStack {
                    Text("Player Name")
                        .font(.title)
                        .fontWeight(.bold)
                        .onAppear {
                            showPDF = false
                        }
                    pdfView
                }
            }
            PitchTendenciesReportView(playerViewing: playersViewing,
                                      pitchCounts: getPitchInformation(withPitcherHand: .Left),
                                      playerEditing: .Hitter,
                                      pitcherHand: .Left,
                                      extraInfo: "(LHP)")
                .environmentObject(gameViewModel)
                .environmentObject(pitchTendenciesViewModel)
                .tabItem { Text("LHP") }
            PitchTendenciesReportView(playerViewing: playersViewing,
                                      pitchCounts: getPitchInformation(withPitcherHand: .Right),
                                      playerEditing: .Hitter,
                                      pitcherHand: .Right,
                                      extraInfo: "(RHP)")
                .environmentObject(gameViewModel)
                .environmentObject(pitchTendenciesViewModel)
                .tabItem { Text("RHP") }
        }.navigationBarItems(trailing:
            Button(action: {
                exportToPDF()
        }, label: {
            Image(systemName: "square.and.arrow.up")
        }))
    }
    
    
    func exportToPDF() {
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("PitchTendencies.pdf")

        //Normal with
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
            
        let chartsLeft = PitchTendenciesReportView(playerViewing: playersViewing,
                                                   pitchCounts: getPitchInformation(withPitcherHand: .Left),                                                   pdfMode: true,
                                                   playerEditing: .Hitter,
                                                   pitcherHand: .Left,
                                                   extraInfo: "(LHP)")
                         .environmentObject(gameViewModel)
                         .environmentObject(pitchTendenciesViewModel)
       let chartsRight = PitchTendenciesReportView(playerViewing: playersViewing,
                                                   pitchCounts: getPitchInformation(withPitcherHand: .Right),
                                                   
                                                   pdfMode: true,
                                                   playerEditing: .Hitter,
                                                   pitcherHand: .Right,
                                                   extraInfo: "(RHP)")
                            .environmentObject(gameViewModel)
                            .environmentObject(pitchTendenciesViewModel)
        let pdfVC = UIHostingController(rootView: chartsLeft)
        let pdfVC2 = UIHostingController(rootView: chartsRight)
        pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        pdfVC2.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

        //Render the view behind all other views
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        rootVC?.addChild(pdfVC)
        rootVC?.addChild(pdfVC2)
        rootVC?.view.insertSubview(pdfVC.view, at: 0)
        rootVC?.view.insertSubview(pdfVC2.view, at: 0)

        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))

        do {
            try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                context.beginPage()
                pdfVC.view.layer.render(in: context.cgContext)
                context.beginPage()
                pdfVC2.view.layer.render(in: context.cgContext)
            })

            self.pdfView = PDFViewUI(url: outputFileURL)
            self.showPDF = true

        }catch {
            // self.showError = true
            print("Could not create PDF file: \(error)")
        }

        print(outputFileURL)
        
        pdfVC.removeFromParent()
        pdfVC.view.removeFromSuperview()
        pdfVC2.removeFromParent()
        pdfVC2.view.removeFromSuperview()
    }

    func getPitchInformation(withPitcherHand pitcherHand: HandUsed) -> [PitchLocation : [PitchType : Int]] {
        var pitchZoneCountSummary : [PitchLocation : [PitchType : Int]] = [:]
        
        // var pitchCounts : [PitchType : Int] = [:]
        for player in playersViewing {
            let summary = pitchTendenciesViewModel
                .generatePitchesSummaryByZone(withGameViewModel: gameViewModel,
                                              pitcherHand: pitcherHand,
                                              withHitter: player)
            
            for zones in summary {
                var zoneSummary = pitchZoneCountSummary[zones.key] ?? [:]
                for pitch in zones.value {
                    var currentPitches = zoneSummary[pitch.key] ?? 0
                    currentPitches += pitch.value
                    zoneSummary.updateValue(currentPitches, forKey: pitch.key)
                }
                pitchZoneCountSummary.updateValue(zoneSummary, forKey: zones.key)
            }
//
//                pitchCounts = pitchTendenciesViewModel
//                    .generatePitchesSummary(withGameViewModel: gameViewModel,
//                            forZone: pitchLocation,
//                            forPitcher: player)
        }
        print(pitchZoneCountSummary)
        return pitchZoneCountSummary
    }
}
