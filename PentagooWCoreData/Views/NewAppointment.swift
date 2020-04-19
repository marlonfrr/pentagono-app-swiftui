//
//  NewAppointment.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import CoreData

struct NewAppointment: View {
    @State var subject = ""
    @State var time = ""
    @State var tutor = ""
    @State var isLoading = false
    @State var isSuccessful = false
    @State var showAlert = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var back
    @ObservedObject var viewRouter: ViewRouter
    
    func create() {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("tutorias").addDocument(data: [
            "subject": self.subject,
            "time": self.time,
            "tutor": self.tutor
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                return
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        let entity =  NSEntityDescription.entity(forEntityName: "TutoriaCache", in: self.managedObjectContext)
        let cachedTutoria = TutoriaCache(entity: entity!, insertInto: self.managedObjectContext)
        cachedTutoria.id = ref!.documentID
        cachedTutoria.subject = self.subject
        cachedTutoria.time = self.time
        cachedTutoria.tutor = self.tutor
        
        do{
            try self.managedObjectContext.save()
            print("Guardado correctamente")
            self.back.wrappedValue.dismiss()
        } catch let error as NSError {
            print("Error al guardar tutoria en caché", error.localizedDescription)
        }
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 18){
                Text("¿Cuál materia?")
                TextField("Materia", text: $subject).textFieldStyle(RoundedBorderTextFieldStyle())
                Text("¿Cuánto tiempo?")
                TextField("time", text: $time).textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Selecciona tutor")
                TextField("Seleciona Tutor", text: $tutor).textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                Button(action: {
                    self.create()
                }) {
                    Text("Agendar")
                }
                Spacer()
            }
        }.navigationBarTitle("Crear nueva tutoría")
    }
}

struct NewAppointment_Previews: PreviewProvider {
    static var previews: some View {
        NewAppointment(viewRouter: ViewRouter())
    }
}
