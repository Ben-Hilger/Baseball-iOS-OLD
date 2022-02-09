// Copyright 2021-Present Benjamin Hilger

import SwiftUI
import PDFKit

struct PDFViewUI : UIViewControllerRepresentable {
    
    var url : URL
    
    func makeUIViewController(context: Context) -> PrintViewController {
        let controller = PrintViewController()
        controller.url = url
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: PrintViewController, context: Context) {}
    
    typealias UIViewControllerType = PrintViewController
//
//    var url: URL?
//    init(url: URL) {
//        self.url = url
//    }
//
////        // Present print controller like usual view controller. Also completionHandler is available if needed.
////        printController.present(animated: true)
////        let pdfView = PDFView()
////
////        if let url = url {
////            pdfView.document = PDFDocument(url: url)
////        }
////
////        return pdfView
//    }
//    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFViewUI>) -> UIPrintInteractionController {
//        // UIPrintInteractionController presents a user interface and manages the printing
//        let printController = UIPrintInteractionController.shared
//
//        // UIPrintInfo contains information about the print job
//        let printInfo = UIPrintInfo()
//        printInfo.outputType = .general
//        printInfo.jobName = "myPrintJob"
//        printController.printInfo = printInfo
//
//        // You can also format printing text, for example, the insets for the printing page
//        let formatter = UIMarkupTextPrintFormatter(markupText: "TestDevLab blog 2018")
//        formatter.perPageContentInsets = UIEdgeInsets(top: 90, left: 90, bottom: 90, right: 90)
//        printController.printFormatter = formatter
//
//        // Present print controller like usual view controller. Also completionHandler is available if needed.
//        return printController
//    }
}

class PrintViewController : UIViewController {
    
    var url : URL!
    
    override func viewDidLoad() {
        // UIPrintInteractionController presents a user interface and manages the printing
        let printController = UIPrintInteractionController.shared

        // UIPrintInfo contains information about the print job
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = url.absoluteString
        printInfo.duplex = .none
        printInfo.orientation = .portrait
        
        printController.printPageRenderer = nil
        printController.printingItems = nil
        printController.printingItem = url
        

        printController.printInfo = printInfo
        // Present print controller like usual view controller. Also completionHandler is available if needed.
        printController.present(animated: true)

    }
}

