//
//  Appointments.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Firebase
import CoreData

struct Appointments: View {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var datos = GetTutorias()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: TutoriaCache.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TutoriaCache.tutor, ascending: true)]) var tutorias: FetchedResults<TutoriaCache>
    func login() {
        
    }
    
    var body: some View {
        
        NavigationView{
            HStack(){
                if ReachabilityHandlerR().isConnectedToNetwork() {
                    VStack(){
                        HStack{
                            NavigationLink(destination: NewAppointment(viewRouter: ViewRouter())
                                .environment(\.managedObjectContext, managedObjectContext)
                            ){
                                Text("Reservar una tutoría")
                                    .font(.system(size: 20, weight: .light))
                            }
                            NavigationLink(destination:
                                CollectionView(viewRouter: ViewRouter())
                                .environment(\.managedObjectContext, managedObjectContext)
                            ){
                                Text("Ver ejercicios")
                                    .font(.system(size: 20, weight: .light))
                            }
                        }
                        List{
                            ForEach(self.datos.datos){item in
                                VStack(alignment: .leading){
                                    Text("Tutoría de \(item.subject) con \(item.tutor)")
                                    Text("Tutoría de \(item.time) horas")
                                }
                            }
                        }
                        Spacer()
                    }
                } else {
                    VStack(){
                        Text("No tienes conexión a internet, viendo citas guardadas")
                        List{
                            ForEach(self.tutorias){item in
                                VStack(alignment: .leading){
                                    Text("Tutoría de \(item.subject) con \(item.tutor)")
                                    Text("Tutoría de \(item.time) horas")
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
                
            }.navigationBarTitle("Tus tutorías", displayMode: .large).navigationBarItems(leading: Button(action:{
                try! Auth.auth().signOut()
                self.viewRouter.logged = false
                UserDefaults.standard.removeObject(forKey: "logged")
                let cachedTutoria = TutoriaCache(context: self.managedObjectContext)
            }){
                Text("Cerrar sesión")
            })
        }.onAppear(){
            
        }
    }
}

struct Appointments_Previews: PreviewProvider {
    static var previews: some View {
        Appointments(viewRouter: ViewRouter())
    }
}
