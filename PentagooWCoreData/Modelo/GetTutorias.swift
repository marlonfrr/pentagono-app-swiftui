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
        db.collection("reservas").whereField("idEstudiante", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener{ (QuerySnapshot, error) in
            if let error = error {
                print("Error al traer los datos")
            } else {
                self.datos.removeAll()
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
                for document in QuerySnapshot!.documents{
                    let valor = document.data()
                    let id = document.documentID
                    let idEstudiante = valor["idEstudiante"] as? String ?? "Sin id estudiante"
                    let idMonitor = valor["idMonitor"] as? String ?? "Sin id monitor"
                    let materia = valor["materia"] as? String ?? "Sin materia"
                    let tema = valor["tema"] as? String ?? "Sin tema"
                    let cancelada = valor["cancelara"] as? Bool ?? false
                    let asistio = valor["asistio"] as? Bool ?? false
                    let dateF = dateFormatterGet.date(from: valor["fechaFin"] as! String)?.timeIntervalSince1970
                    let dateI = dateFormatterGet.date(from: valor["fechaInicio"] as! String)?.timeIntervalSince1970
                    let rating = valor["rating"] as? Int16 ?? 0
                    let comentario = valor["comentario"] as? String ?? "Sin comentario"
                    // Always necessary when fetching data from internet
                    DispatchQueue.main.async {
                        let registros = Tutoria(id: id, idMonitor: idMonitor, idEstudiante: idEstudiante, materia: materia, tema: tema, rating: rating, comentario: comentario, cancelada: cancelada, asistio: asistio, fechaFin: dateF!, fechaInicio: dateI!)
                        print(registros)
                        self.datos.append(registros)
                    }
                }
            }
        }
    }
}
