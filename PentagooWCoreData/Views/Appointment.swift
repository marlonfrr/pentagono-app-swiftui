//
//  Appointment.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 24/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI

struct Appointment: View {
    
    var param : Tutoria
    @State var now = Date().timeIntervalSince1970
    @State var comentario: String = ""
    
    func aisd(date: Double)->String{
        print(now)
        let dateFormatterGet = DateFormatter();
        dateFormatterGet.dateFormat = "dd-MM HH:mm";
        return dateFormatterGet.string(from: Date(timeIntervalSince1970: date))
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
                        } else if now>param.fechaInicio&&now<param.fechaFin {
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
                    Button(action: {}, label:{ HStack{
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
                        TextField("1-5", text: self.$comentario).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 70).keyboardType(.numberPad)
                    }
                    TextField("Comentarios", text: self.$comentario).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Spacer()
            }.padding(.all).navigationBarTitle("Monitoría de \(param.materia)").navigationBarItems(trailing: Text("Cancelar"))
        }
        //        }
    }
}



struct Appointment_Previews: PreviewProvider {
    static var previews: some View {
        Appointment(param: Tutoria(id: "vm63gl7gwjbnH6BhLgxF", idMonitor: "7pYpyq7wXjmDNszb08JH", idEstudiante: "uLXLhj07EigBuGDRtAlsoBLYOhD2", materia: "Precalculo", tema: "Lo que sea", rating: 0, comentario: "", cancelada: false, asistio: false, fechaFin: 1588086000.0, fechaInicio: 1588078800.0))
    }
}
