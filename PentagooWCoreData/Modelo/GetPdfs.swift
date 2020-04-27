//
//  GetPdfs.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 26/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation
import Combine

class GetPdfs: ObservableObject {
    @Published var pdfs = [URL]()
    
    func fetchPdfs(materia: String) {
        
        let obj = Materia(texto: materia)
        
//        guard let encoded = try? JSONEncoder().encode(obj)
//            else {
//                print("No encondeó")
//                return;
//        }
        
//        print(encoded)
        
        let url = URL(string : "http://pentagonoanalytics.herokuapp.com/buscar")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
//        request.httpBody = encoded
        request.httpBody = try? JSONEncoder().encode(obj)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                print("No data \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let obj = try! JSONDecoder().decode(PdfObject.self, from: data)
            print("pdfs:")
            print(obj)
            for doc in obj.links {
//                let casiUrl = doc.addingPercentEncoding(withAllowedCharacters: .whitespaces)
                let casiUrl = doc.replacingOccurrences(of: " ", with: "%20")
                let url = URL(string: casiUrl)
                DispatchQueue.main.async {
                    self.pdfs.append(url!)
                }
            }
        }.resume()
    }
}
