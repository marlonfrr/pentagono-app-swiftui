//
//  ExerciseViewer.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 25/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import PDFKit

struct ExerciseViewer: UIViewRepresentable {
    
//    var url : URL? = URL(string: "http://www.africau.edu/images/default/sample.pdf")
//    var url : URL? = URL(string: "https://storage.googleapis.com/docspentagono/E.%20Final%20(A)%20C.%20Vectorial%20MATE%201207%202017-2.pdf")
    var url : URL?
    
    func makeUIView(context: Context) -> UIView {
        let pdfView = PDFView()
        print(url)
        if let url = self.url {
            pdfView.document = PDFDocument(url:url)
        }
        print("No lo hizo")
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // empty
    }
}

//struct ExerciseViewer_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseViewer()
//    }
//}
