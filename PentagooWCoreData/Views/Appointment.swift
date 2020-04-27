//
//  Appointment.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 24/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct Appointment: View {
    
    var param : Tutoria
    @State var now = Date().timeIntervalSince1970
    @State var comentario: String = ""
    @State var puntaje: String = "0"
    @State var isAlert: Bool = false
    @State var start: Bool = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var back
    
    func aisd(date: Double)->String{
        print(now)
        let dateFormatterGet = DateFormatter();
        dateFormatterGet.dateFormat = "dd-MM HH:mm";
        return dateFormatterGet.string(from: Date(timeIntervalSince1970: date))
    }
    
    func guardarPuntaje(){
        let db = Firestore.firestore()
        let monitorRef = db.collection("reservas").document(self.param.id)
        monitorRef.updateData([
            "comentario": self.comentario,
            "rating": Int(self.puntaje)!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Puntaje guardado")
                self.back.wrappedValue.dismiss()
            }
        }
    }
    
    func cancelar(){
        print("aa")
        let db = Firestore.firestore()
        let monitorRef = db.collection("reservas").document(self.param.id)
        monitorRef.updateData([
            "cancelada": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Cancelada")
                self.back.wrappedValue.dismiss()
            }
        }
    }
    
    var body: some View {
        
        ScrollView{
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "book.fill").resizable().frame(width: 40, height: 40).clipped().padding(.all).background(Color.yellow).cornerRadius(50)
                    VStack(alignment: .leading){
                        Text("De \(aisd(date: param.fechaInicio)) a \(aisd(date: param.fechaFin))").fontWeight(.bold)
                        if now<param.fechaInicio {
                            if param.cancelada{
                                Text("Tu monitoría fue cancelada")
                            } else {
                                Text("Tu monitoría no ha sido cancelada")
                            }
                            Image(systemName: "circle.fill").resizable().frame(width: 20, height: 20).foregroundColor(param.cancelada ? Color.red : Color.green)
                        } else if now>param.fechaInicio&&now<param.fechaFin{
                            Text("Inicia tu monitoría")
                        }else if now>param.fechaFin {
                            Text("Tu monitoría finalizó")
                        }
                    }
                }
                Spacer()
                Text("Asiste a tu monitoría").font(.largeTitle).bold()
                if now<param.fechaInicio {
                    Text("Podrás asistir a la monitoría a la hora indicada")
                } else if now>param.fechaInicio&&now<param.fechaFin {
                    VStack(alignment: .center){
                    Text("Entra a tu monitoría a través de Whatsapp")
                        Button(action: {self.start=true}, label:{ HStack{
                        Image("waicon").renderingMode(.original).resizable().aspectRatio(contentMode: .fill).frame(width: 80, height: 80)}})
                    }
                } else if now>param.fechaFin {
                    Text("Tu monitoría finalizó")
                }
                Text("Califica tu monitoría").font(.largeTitle).bold()
                if now<param.fechaFin {
                    Text("Podrás calificar cuando termine tu monitoría")
                } else {
                    HStack{
                        Text("Puntaje")
                        TextField("1-5", text: self.$puntaje).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 70).keyboardType(.numberPad)
                    }
                    TextField("Comentarios", text: self.$comentario).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {self.guardarPuntaje()}, label: {
                                    Text("Guardar").foregroundColor(.white)
                                }).padding(.all).background(Color.green).cornerRadius(20).padding(.bottom, 8)
                }
                Spacer()
            }.padding(.all).navigationBarTitle("Monitoría de \(param.materia)").navigationBarItems(trailing: Button(action: {self.isAlert = true}, label: {
                HStack{
                    Image(systemName: "xmark.circle.fill").foregroundColor(now>param.fechaInicio ? Color.gray:Color.red)
                    Text("Cancelar").foregroundColor(now>param.fechaInicio ? Color.gray:Color.red)
                }
            }))
        }.alert(isPresented: self.$isAlert) { () -> Alert in
                Alert(title: Text("Cancelar tutoría"), message: Text("¿Estás seguro de cancelar la tutoría?"), primaryButton: .default(Text("Sí"), action: {
                    self.cancelar()
                }), secondaryButton: .default(Text("Volver")))
        }
    }
}



struct Appointment_Previews: PreviewProvider {
    static var previews: some View {
        Appointment(param: Tutoria(id: "vm63gl7gwjbnH6BhLgxF", idMonitor: "7pYpyq7wXjmDNszb08JH", idEstudiante: "uLXLhj07EigBuGDRtAlsoBLYOhD2", materia: "Precalculo", tema: "Lo que sea", rating: 0, comentario: "", cancelada: false, asistio: false, fechaFin: 1588086000.0, fechaInicio: 1588078800.0))
    }
}
