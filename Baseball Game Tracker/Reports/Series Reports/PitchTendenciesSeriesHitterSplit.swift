//
//  PitchTendenciesSeriesHitterSplit.swift
//  Baseball Game Tracker
//
//  Created by Benjamin Hilger on 3/20/21.
//

import Foundation
import SwiftUI

struct PitchTendenciesSeriesReportHitterSplit : View {

    @EnvironmentObject var pitchTendenciesViewModel: PitchTendenciesSeriesReportViewModel
    
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
            PitchTendenciesSeriesReportView(playerViewing: playersViewing,
                                      playerEditing: .Hitter,
                                      pitcherHand: .Left,
                                      extraInfo: "(LHP)")
                .environmentObject(pitchTendenciesViewModel)
                .tabItem { Text("LHP") }
            PitchTendenciesSeriesReportView(playerViewing: playersViewing,
                                      playerEditing: .Hitter,
                                      pitcherHand: .Right,
                                      extraInfo: "(RHP)")
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
            
        let chartsLeft = PitchTendenciesSeriesReportView(playerViewing: playersViewing,
                                                         pdfMode: true, playerEditing: .Hitter,
                                                         pitcherHand: .Left,
                                                         extraInfo: "(LHP)")
                         .environmentObject(pitchTendenciesViewModel)
       let chartsRight = PitchTendenciesSeriesReportView(playerViewing: playersViewing,
                                                         pdfMode: true, playerEditing: .Hitter,
                                                         pitcherHand: .Right,
                                                         extraInfo: "(RHP)")
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
}
