//
//  Home.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Firebase
import CoreData

struct Home: View {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var datos = GetTutorias()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: TutoriaCache.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TutoriaCache.id, ascending: true)]) var tutorias: FetchedResults<TutoriaCache>
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM HH:mm"
        return formatter
    }()
    
    var body: some View {
        
        NavigationView{
            HStack(){
                if ReachabilityHandlerR().isConnectedToNetwork() {
                    VStack(){
                        List{
                            ForEach(self.datos.datos){item in
                                NavigationLink(destination: Appointment(param: item)){
                                    HStack {
                                        Image(systemName: "book.circle.fill").resizable().frame(width: 20, height: 20).clipShape(Circle()).padding(.all, 10).background(Color.yellow).cornerRadius(20).padding(.trailing, 8)
                                        VStack(alignment: .leading){
                                            Text("Tutoría").bold()
                                            Text("Materia: \(item.materia)")
                                            Text("Fecha: \(Date(timeIntervalSince1970: TimeInterval(item.fechaInicio)), formatter: Self.taskDateFormat)")
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                        NavigationLink(destination: NewAppointment(viewRouter: ViewRouter())
                            .environment(\.managedObjectContext, managedObjectContext)
                        ){
                            HStack {
                                Text("Reservar tutoría").foregroundColor(.black).padding(.all, 12)
                            }.background(Color.yellow)
                                .cornerRadius(20).padding(.bottom, 8)
                        }
                    }
                } else {
                    VStack(){
                        Text("No tienes conexión a internet, viendo citas guardadas")
                        List{
                            ForEach(self.tutorias){item in
                                HStack {
                                    Image(systemName: "book.circle.fill").resizable().frame(width: 20, height: 20).clipShape(Circle()).padding(.all, 10).background(Color.yellow).cornerRadius(20).padding(.trailing, 8)
                                    VStack(alignment: .leading){
                                        Text("Tutoría").bold()
                                        Text("Materia: \(item.materia)")
                                        Text("Fecha: \(Date(timeIntervalSince1970: TimeInterval(item.fechaInicio)), formatter: Self.taskDateFormat)")
                                    }
                                }
                            }.onDelete { (IndexSet) in
                                let borrarTutoria = self.tutorias[IndexSet.first!]
                                self.managedObjectContext.delete(borrarTutoria)
                                do{
                                    try self.managedObjectContext.save()
                                } catch let error as NSError {
                                    print("No se borró", error.localizedDescription)
                                }
                            }
                        }
                        Spacer()
                    }.padding(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
                
            }.navigationBarTitle("Tus tutorías", displayMode: .large)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewRouter: ViewRouter())
    }
}
