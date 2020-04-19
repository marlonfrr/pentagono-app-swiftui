//
//  GetTutorias.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation
import Firebase
import Combine
import SwiftUI
import FirebaseFirestore
import CoreData

class GetTutorias: ObservableObject {
    @Published var datos = [Tutoria]()
    @Environment(\.managedObjectContext) var contexto
    
    init(){
        let db = Firestore.firestore()
        db.collection("tutorias").addSnapshotListener{ (QuerySnapshot, error) in
            if let error = error {
                print("Error al traer los datos")
            } else {
                self.datos.removeAll()
                for document in QuerySnapshot!.documents{
                    let valor = document.data()
                    let id = document.documentID
                    let subject = valor["subject"] as? String ?? "Sin materia"
                    let time = valor["time"] as? String ?? "Sin time"
                    let tutor = valor["tutor"] as? String ?? "Sin tutor"
                    
                    // Always necessary when fetching data from internet
                    DispatchQueue.main.async {
                        let registros = Tutoria(id: id, subject: subject, tutor: tutor, time: time)
                        self.datos.append(registros)
                    }
                }
            }
        }
    }
}
